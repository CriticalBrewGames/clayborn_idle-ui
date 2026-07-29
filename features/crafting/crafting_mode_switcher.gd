extends Node

@onready var mode_buttons: HBoxContainer = $"../VBoxContainer/CraftingModeBar/Margin/Buttons"
@onready var discovery_panel: Control = $"../VBoxContainer/CraftingBody/DiscoveryPanel"
@onready var combinator_panel: Control = $"../VBoxContainer/CraftingBody/CombinatorPanel"
@onready var enchantments_panel: Control = $"../VBoxContainer/CraftingBody/EnchantmentsPanel"


func _ready() -> void:
	if mode_buttons and mode_buttons.has_signal("payload_pressed"):
		mode_buttons.payload_pressed.connect(_on_mode_changed)
	_show_mode(&"combinator")


func _on_mode_changed(mode: StringName) -> void:
	_show_mode(mode)


func _show_mode(mode: StringName) -> void:
	discovery_panel.visible = mode == &"discovery"
	combinator_panel.visible = mode == &"combinator"
	enchantments_panel.visible = mode == &"enchantments"
