extends Control

const _SAMPLE_STATS := {
	"resources": {"hp": 120, "mana": 45, "rage": 0},
	"defense": {"resistance": 8, "armour": 14, "evasion": 5},
	"damage": {"attack": 12, "strength": 6, "marksman": 0, "skirmisher": 0, "magic": 3},
	"utility": {
		"mana_regen": 2,
		"attack_speed": 1,
		"cast_speed": 0,
		"magic_efficiency": 0,
		"crit_chance": 0.05,
		"crit_damage": 150,
	},
}

@onready var _hud: Control = $PlayerInventoryHud
@onready var _hint: Label = $Panel/Hint


func _ready() -> void:
	if _hud:
		_hud.set_stats(_SAMPLE_STATS)
		_hud.set_hp(95, 120)
		if _hud.has_signal("payload_pressed"):
			_hud.payload_pressed.connect(_on_hud_payload)


func _on_hud_payload(payload: String) -> void:
	if _hint:
		_hint.text = "Payload emitted: %s (Main handles routing)" % payload
