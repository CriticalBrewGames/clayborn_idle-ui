extends Button

## Bottom icon button. Emits a small string payload for Main to route.

signal payload_pressed(payload: String)

@export var payload: String = ""


func _ready() -> void:
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if payload.is_empty():
		return
	payload_pressed.emit(payload)
