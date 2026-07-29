extends Panel

## Combinator panel wiring hooks. Emits generic signals — Main owns ItemStack logic.

signal slot_changed(slot_id: String, occupied: bool)
signal combine_pressed
signal status_message_changed(message: String)

@onready var input_a: Control = $Margin/VBox/InputsRow/InputAColumn/InputASlot
@onready var input_b: Control = $Margin/VBox/InputsRow/InputBColumn/InputBSlot
@onready var output_slot: Control = $Margin/VBox/OutputColumn/OutputSlot
@onready var catalyst_slot: Control = $Margin/VBox/CatalystPanel/CatalystMargin/CatalystRow/CatalystSlot
@onready var combine_button: Button = $Margin/VBox/CombineButton
@onready var status_label: Label = $Margin/VBox/StatusPanel/StatusLabel

var _slot_occupied: Dictionary = {
	"input_a": false,
	"input_b": false,
	"output": false,
	"catalyst": false,
}


func _ready() -> void:
	if combine_button:
		combine_button.pressed.connect(_on_combine_pressed)
	_wire_slot(input_a, "input_a")
	_wire_slot(input_b, "input_b")
	_wire_slot(output_slot, "output")
	_wire_slot(catalyst_slot, "catalyst")


func set_slot_occupied(slot_id: String, occupied: bool) -> void:
	_slot_occupied[slot_id] = occupied
	slot_changed.emit(slot_id, occupied)
	_refresh_status()


func get_slot_host(slot_id: String) -> Control:
	match slot_id:
		"input_a":
			return input_a
		"input_b":
			return input_b
		"output":
			return output_slot
		"catalyst":
			return catalyst_slot
		_:
			return null


func set_status(message: String) -> void:
	if status_label:
		status_label.text = message
	status_message_changed.emit(message)


func _wire_slot(slot: Control, slot_id: String) -> void:
	if not slot:
		return
	# Visual item_slot panels can emit gui clicks; Main should call set_slot_occupied
	# after mounting inventory views. Still expose a click hint signal path.
	if slot.has_signal("gui_input"):
		pass
	slot.set_meta("slot_id", slot_id)


func _on_combine_pressed() -> void:
	combine_pressed.emit()


func _refresh_status() -> void:
	if _slot_occupied.get("input_a", false) and _slot_occupied.get("input_b", false):
		set_status(tr("CRAFTING_STATUS_COMBINATION_READY"))
	elif _slot_occupied.get("input_a", false) or _slot_occupied.get("input_b", false):
		set_status(tr("CRAFTING_STATUS_NEED_TWO"))
	else:
		set_status(tr("CRAFTING_STATUS_PLACE_ITEMS"))
