extends Node

@onready var mode_buttons: HBoxContainer = $"../VBoxContainer/ShopModeBar/Margin/Buttons"
@onready var buy_panel: Control = $"../VBoxContainer/ShopBody/BuyPanel"
@onready var sell_panel: Control = $"../VBoxContainer/ShopBody/SellPanel"


func _ready() -> void:
	if mode_buttons and mode_buttons.has_signal("mode_changed"):
		mode_buttons.mode_changed.connect(_on_mode_changed)
	_show_mode(&"buy")


func _on_mode_changed(mode: StringName) -> void:
	_show_mode(mode)


func _show_mode(mode: StringName) -> void:
	buy_panel.visible = mode == &"buy"
	sell_panel.visible = mode == &"sell"
