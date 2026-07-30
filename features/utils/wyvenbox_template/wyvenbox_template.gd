@tool
class_name WyvenboxTemplate extends Panel

enum PlaceholderType {
	GRID,
	CELL
}

static var _EMPTY_STYLE: StyleBoxEmpty = StyleBoxEmpty.new()

@onready var placeholder_label: Label = $Placeholder 

@export var template_name: String = "":
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


var injected_inventory: InventoryView


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

	placeholder_label.text = "%s\n%s" % [tr(template_name) if not template_name.is_empty() else "", type_text]


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


func inject_inventory(inventory_scene: PackedScene) -> void:
	if not inventory_scene:
		push_warning("WyvenboxTemplate: No PackedScene provided for injection.")
		return
	
	if is_instance_valid(injected_inventory):
		var root_to_free = injected_inventory.get_parent() if injected_inventory.get_parent() != self else injected_inventory
		root_to_free.queue_free()
	
	var instance = inventory_scene.instantiate()
	
	var view = _get_inventory_view(instance)
	
	if not view:
		push_error("WyvenboxTemplate: Neither root nor first child of '%s' is an InventoryView." % inventory_scene.resource_path)
		instance.queue_free()
		return
	
	injected_inventory = view
	
	if placeholder_label:
		placeholder_label.visible = false
	add_theme_stylebox_override("panel", _EMPTY_STYLE)
	
	add_child(instance)
