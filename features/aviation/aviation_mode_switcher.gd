extends Node

@onready var mode_buttons: HBoxContainer = $"../VBoxContainer/AviationModeBar/Margin/Buttons"
@onready var travel_panel: Control = $"../VBoxContainer/AviationBody/TravelPanel"
@onready var hangar_panel: Control = $"../VBoxContainer/AviationBody/HangarPanel"


func _ready() -> void:
	if mode_buttons and mode_buttons.has_signal("payload_pressed"):
		mode_buttons.payload_pressed.connect(_on_mode_changed)
	_show_mode(&"travel")


func _on_mode_changed(mode: StringName) -> void:
	_show_mode(mode)


func _show_mode(mode: StringName) -> void:
	travel_panel.visible = mode == &"travel"
	hangar_panel.visible = mode == &"hangar"
