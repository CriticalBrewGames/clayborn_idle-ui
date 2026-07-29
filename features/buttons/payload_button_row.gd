extends Control

## Forwards PayloadButton child presses. Pair with a ButtonGroupBinder for exclusive toggles.

signal payload_pressed(payload: StringName)


func _ready() -> void:
	for child in get_children():
		if child.has_signal("payload_pressed"):
			if not child.payload_pressed.is_connected(_forward_payload):
				child.payload_pressed.connect(_forward_payload)


func _forward_payload(payload: StringName) -> void:
	payload_pressed.emit(payload)
