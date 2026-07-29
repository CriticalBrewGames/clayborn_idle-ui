extends PayloadButton

## Utility side-bar button with icon + label. Payload routing comes from PayloadButton.

@export var button_icon: Texture2D
@export var button_text: String

@onready var icon_texture_rect: TextureRect = $HBoxContainer/IconText
@onready var button_label: Label = $HBoxContainer/Label


func _ready() -> void:
	super._ready()
	if button_icon:
		icon_texture_rect.texture = button_icon
	if button_text:
		button_label.text = tr(button_text)
