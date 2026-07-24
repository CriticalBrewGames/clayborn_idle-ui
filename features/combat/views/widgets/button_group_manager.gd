extends RefCounted
class_name ButtonGroupManager

signal button_pressed(payload)

var button_grp := ButtonGroup.new()


func setup_buttons(buttons: Array[BaseButton]) -> void:
	for button in buttons:
		button.button_group = button_grp
		button.toggle_mode = true
	button_grp.pressed.connect(_on_button_pressed)


func _on_button_pressed(button: BaseButton) -> void:
	if "payload" in button:
		button_pressed.emit(button.payload)


func get_currently_pressed_button() -> BaseButton:
	return button_grp.get_pressed_button()
