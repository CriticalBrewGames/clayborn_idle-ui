class_name PayloadButton extends Button

signal payload_pressed(payload: StringName)

@export var payload: StringName = &""


func _ready() -> void:
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if payload.is_empty():
		return
	payload_pressed.emit(payload)
