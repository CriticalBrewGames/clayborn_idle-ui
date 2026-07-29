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


func inject_invetory(inventory: InventoryView) -> void:
	injected_inventory = inventory
	placeholder_label.visible = false
	
	add_theme_stylebox_override("panel", _EMPTY_STYLE)
	
	add_child(inventory)
