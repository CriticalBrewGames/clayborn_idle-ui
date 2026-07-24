extends Control

signal style_selected(payload: int)

var button_manager := ButtonGroupManager.new()
var _buttons: Array[BaseButton] = []


func _ready() -> void:
	for node in get_children():
		if node is BaseButton:
			_buttons.append(node)
	button_manager.setup_buttons(_buttons)
	button_manager.button_pressed.connect(_on_payload_selected)


func select_button_by_payload(payload: int) -> void:
	for button in _buttons:
		if "payload" in button and button.payload == payload:
			button.button_pressed = true
			break


func _on_payload_selected(payload: int) -> void:
	style_selected.emit(payload)
