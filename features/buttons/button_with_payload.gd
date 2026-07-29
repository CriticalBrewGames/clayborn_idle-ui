class_name PayloadButton extends Button

signal payload_pressed(payload: String)

@export var payload: String = ""

func _on_pressed() -> void:
	if payload.is_empty():
		return
	payload_pressed.emit(payload)
