@tool
class_name WyvenboxTemplate extends Panel

## Empty inventory socket for Main to inject Wyvernbox InventoryViews into.
## Dynamic scenes (bank, shop, crafting, combat drops) and static HUD hosts share this API.

enum PlaceholderType {
	GRID,
	CELL
}

static var _EMPTY_STYLE: StyleBoxEmpty = StyleBoxEmpty.new()

@onready var placeholder_label: Label = $Placeholder

@export var template_name: StringName = &"":
	set(value):
		template_name = value
		_update_placeholder()

@export var inventory_size: Vector2i = Vector2i.ZERO:
	set(value):
		inventory_size = value
		_update_placeholder()

@export var inventory_type: PlaceholderType = PlaceholderType.GRID:
	set(value):
		inventory_type = value
		_update_placeholder()

## Live InventoryView currently hosted by this template (set by inject_*).
var injected_inventory: InventoryView

## True when the current injected view was created by [method inject_inventory]
## (safe to free on replace). False when Main re-hosted an existing view.
var _owns_injected: bool = false


func _ready() -> void:
	_update_placeholder()


func _update_placeholder() -> void:
	if not is_inside_tree():
		return
	if not placeholder_label:
		return

	var type_text: String
	if inventory_type == PlaceholderType.GRID:
		type_text = tr("WYVENBOX_GRID") % [inventory_size.x, inventory_size.y]
	else:
		type_text = tr("WYVENBOX_CELL")

	placeholder_label.text = "%s\n%s" % [
		tr(template_name) if not template_name.is_empty() else "",
		type_text,
	]


func _get_inventory_view(root: Node) -> InventoryView:
	if not root:
		return null
	if root is InventoryView:
		return root as InventoryView
	if root.get_child_count() > 0:
		var first_child = root.get_child(0)
		if first_child is InventoryView:
			return first_child as InventoryView
	return null


## Instantiate a PackedScene that roots (or wraps) an InventoryView and host it.
## Applies [member inventory_size] to GridInventory when size is positive.
## Returns the hosted InventoryView, or null on failure.
func inject_inventory(inventory_scene: InventoryView) -> InventoryView:
	if not inventory_scene:
		push_warning("WyvenboxTemplate[%s]: No PackedScene provided for injection." % template_name)
		return null
	
	_clear_previous_injection()
	
	_ensure_inventory(inventory_scene)
	_apply_size_to_view(inventory_scene)
	_prepare_host_chrome()
	add_child(inventory_scene)
	_layout_injected(inventory_scene)
	injected_inventory = inventory_scene
	_owns_injected = true
	return inventory_scene


## Re-host an existing InventoryView (e.g. player bag moved between desktop / popup).
## Does not free the previous view when it is the same instance being re-mounted.
func inject_inventory_view(view: InventoryView) -> InventoryView:
	if view == null:
		push_warning("WyvenboxTemplate[%s]: Null InventoryView for injection." % template_name)
		return null

	if injected_inventory == view and view.get_parent() == self:
		_prepare_host_chrome()
		_layout_injected(view)
		return view

	_clear_previous_injection()
	_prepare_host_chrome()
	if view.get_parent() != self:
		if view.get_parent():
			view.get_parent().remove_child(view)
		add_child(view)
	_layout_injected(view)
	injected_inventory = view
	_owns_injected = false
	return view


func clear_injection() -> void:
	_clear_previous_injection()


func get_injected_inventory() -> InventoryView:
	return injected_inventory


func _clear_previous_injection() -> void:
	if not is_instance_valid(injected_inventory):
		injected_inventory = null
		_owns_injected = false
		return

	var previous: InventoryView = injected_inventory
	injected_inventory = null
	if _owns_injected:
		var root_to_free: Node = previous.get_parent() if previous.get_parent() != self else previous
		if is_instance_valid(root_to_free):
			root_to_free.queue_free()
	elif previous.get_parent() == self:
		remove_child(previous)
	_owns_injected = false


func _ensure_inventory(view: InventoryView) -> void:
	## Prefab scenes from Main/Wyvernbox usually ship with an Inventory already.
	## UI standalone has no GridInventory — leave null for previews.
	if view == null or view.inventory != null:
		return


func _apply_size_to_view(view: InventoryView) -> void:
	if view == null or view.inventory == null:
		return
	if not ("width" in view.inventory and "height" in view.inventory):
		return
	if inventory_type == PlaceholderType.CELL:
		view.inventory.width = 1
		view.inventory.height = 1
		return
	if inventory_size.x > 0 and inventory_size.y > 0:
		view.inventory.width = inventory_size.x
		view.inventory.height = inventory_size.y


func _prepare_host_chrome() -> void:
	if placeholder_label:
		placeholder_label.visible = false
	add_theme_stylebox_override("panel", _EMPTY_STYLE)


func _layout_injected(node: Control) -> void:
	if node == null:
		return
	node.set_anchors_preset(Control.PRESET_FULL_RECT)
	node.offset_left = 0
	node.offset_top = 0
	node.offset_right = 0
	node.offset_bottom = 0
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	node.size_flags_vertical = Control.SIZE_EXPAND_FILL
