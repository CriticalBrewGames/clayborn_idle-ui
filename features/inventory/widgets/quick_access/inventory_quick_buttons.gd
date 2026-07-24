extends Control

## Bottom-left quick access buttons for inventory / gear / stats on small and medium breakpoints.
## Emits string payloads for Main to route into popup panels.

signal payload_pressed(payload: String)

@onready var _inventory_button: Button = $InventoryButton
@onready var _gear_button: Button = $GearButton
@onready var _stats_button: Button = $StatsButton


func _ready() -> void:
	_wire_payload_button(_inventory_button)
	_wire_payload_button(_gear_button)
	_wire_payload_button(_stats_button)


func get_stats_button() -> Control:
	return _stats_button


func _wire_payload_button(button: Node) -> void:
	if button == null:
		return
	if button.has_signal("payload_pressed"):
		if not button.payload_pressed.is_connected(_forward_payload):
			button.payload_pressed.connect(_forward_payload)


func _forward_payload(payload: String) -> void:
	payload_pressed.emit(payload)
