class_name PayloadButton extends Button

signal payload_pressed(payload: StringName)
signal action_request(payload: StringName)

enum Handleing {
	REQUEST,
	ACTION
}

@export var payload: StringName = &""
@export var handleing: Handleing
@export var button_export: bool = true # If true the payload will be trasnfered to the router/dispatchers

func _ready() -> void:
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if payload.is_empty():
		return
	match handleing:
		Handleing.REQUEST:
			payload_pressed.emit(payload)
		Handleing.ACTION:
			action_request.emit(payload)
