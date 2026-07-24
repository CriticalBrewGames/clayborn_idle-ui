extends Button

signal stat_button_pressed(status: bool)

@onready var label: Label = $Label

var is_toggled: bool = false:
	set(value):
		_open_panel(value)
		is_toggled = value


func _on_pressed() -> void:
	is_toggled = not is_toggled


func _open_panel(value: bool) -> void:
	if label:
		label.text = ">" if value else "<"
	stat_button_pressed.emit(value)
