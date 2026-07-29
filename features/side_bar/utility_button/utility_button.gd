extends Button

## Utility side-bar button. Emits a small string payload for Main to route.

signal payload_pressed(payload: String)

@export var payload: String = ""
@export var button_icon: Texture2D
@export var button_text: String

@onready var icon_texture_rect: TextureRect = $HBoxContainer/IconText
@onready var button_label: Label = $HBoxContainer/Label

func _ready() -> void:
	if button_icon:
		icon_texture_rect.texture = button_icon
	if button_text:
		button_label.text = tr(button_text)
	
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if payload.is_empty():
		return
	payload_pressed.emit(payload)
