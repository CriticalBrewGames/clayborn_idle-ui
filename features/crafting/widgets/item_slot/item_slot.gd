extends Panel

enum SlotKind { GEAR, CATALYST }

const GEAR_SIZE := Vector2(93, 128)
const CATALYST_SIZE := Vector2(36, 36)

@export var slot_kind: SlotKind = SlotKind.GEAR:
	set(value):
		slot_kind = value
		_apply_size()

@export var placeholder: String = "CRAFTING_SLOT_ITEM":
	set(value):
		placeholder = value
		if label:
			label.text = tr(value) if value != "" else ""

@onready var label: Label = $Label


func _ready() -> void:
	_apply_size()
	if label:
		label.text = tr(placeholder) if placeholder != "" else ""


func _apply_size() -> void:
	var size := GEAR_SIZE if slot_kind == SlotKind.GEAR else CATALYST_SIZE
	custom_minimum_size = size
	custom_maximum_size = size
	if is_inside_tree():
		self.size = size
