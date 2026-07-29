class_name PayloadButton extends Button

signal payload_pressed(payload: StringName)

@export var payload: StringName = &""


func _on_pressed() -> void:
	if payload.is_empty():
		return
	payload_pressed.emit(payload)
