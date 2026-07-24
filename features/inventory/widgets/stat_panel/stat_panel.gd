extends Panel

## Stats chrome. Main calls `set_stats(data)` with nested Dictionary:
## { "resources": {hp, mana, rage}, "defense": {resistance, armour, evasion},
##   "damage": {attack, strength, marksman, skirmisher, magic},
##   "utility": {mana_regen, attack_speed, cast_speed, magic_efficiency, crit_chance, crit_damage} }

signal looked_at(toggled: bool, data: Dictionary)

@onready var hp_label: Label = $Panel/ScrollContainer/VBoxContainer/Resource/VBoxContainer/HP/HpAmount
@onready var mana_label: Label = $Panel/ScrollContainer/VBoxContainer/Resource/VBoxContainer/Mana/Value
@onready var rage_label: Label = $Panel/ScrollContainer/VBoxContainer/Resource/VBoxContainer/Rage/Value
@onready var resistance_label: Label = $Panel/ScrollContainer/VBoxContainer/Defensive/VBoxContainer/Resistance/Value
@onready var armour_label: Label = $Panel/ScrollContainer/VBoxContainer/Defensive/VBoxContainer/Armour/Value
@onready var evasion_label: Label = $Panel/ScrollContainer/VBoxContainer/Defensive/VBoxContainer/Evasion/Value
@onready var attack_label: Label = $Panel/ScrollContainer/VBoxContainer/Damage/VBoxContainer/Attack/Value
@onready var strength_label: Label = $Panel/ScrollContainer/VBoxContainer/Damage/VBoxContainer/Strength/Value
@onready var marksman_label: Label = $Panel/ScrollContainer/VBoxContainer/Damage/VBoxContainer/Marksman/Value
@onready var skirmisher_label: Label = $Panel/ScrollContainer/VBoxContainer/Damage/VBoxContainer/Skirmisher/Value
@onready var magic_label: Label = $Panel/ScrollContainer/VBoxContainer/Damage/VBoxContainer/Magic/Value
@onready var mana_regen_label: Label = $Panel/ScrollContainer/VBoxContainer/Utility/VBoxContainer/ManaRegen/Value
@onready var attack_speed_label: Label = $Panel/ScrollContainer/VBoxContainer/Utility/VBoxContainer/AttackSpeed/Value
@onready var cast_speed_label: Label = $Panel/ScrollContainer/VBoxContainer/Utility/VBoxContainer/CastSpeed/Value
@onready var magic_efficiency_label: Label = $Panel/ScrollContainer/VBoxContainer/Utility/VBoxContainer/MagicEfficiency/Value
@onready var crit_chance_label: Label = $Panel/ScrollContainer/VBoxContainer/Utility/VBoxContainer/CritChance/Value
@onready var crit_damage_label: Label = $Panel/ScrollContainer/VBoxContainer/Utility/VBoxContainer/CritDamage/Value

var _hover_labels: Array[Label] = []


func _ready() -> void:
	_hover_labels = [resistance_label, armour_label, evasion_label]
	for label in _hover_labels:
		if label:
			label.mouse_filter = Control.MOUSE_FILTER_STOP
			label.mouse_entered.connect(_on_mouse_enter.bind(label))
			label.mouse_exited.connect(_on_mouse_exit)


func set_stats(stats: Dictionary) -> void:
	var resources: Dictionary = stats.get("resources", {})
	var defense: Dictionary = stats.get("defense", {})
	var damage: Dictionary = stats.get("damage", {})
	var utility: Dictionary = stats.get("utility", {})

	_set_label(hp_label, resources.get("hp", 0))
	_set_label(mana_label, resources.get("mana", 0))
	_set_label(rage_label, resources.get("rage", 0))

	_set_label(resistance_label, defense.get("resistance", 0))
	_set_label(armour_label, defense.get("armour", 0))
	_set_label(evasion_label, defense.get("evasion", 0))

	_set_label(attack_label, damage.get("attack", 0))
	_set_label(strength_label, damage.get("strength", 0))
	_set_label(marksman_label, damage.get("marksman", 0))
	_set_label(skirmisher_label, damage.get("skirmisher", 0))
	_set_label(magic_label, damage.get("magic", 0))

	_set_label(mana_regen_label, utility.get("mana_regen", 0))
	_set_label(attack_speed_label, utility.get("attack_speed", 0))
	_set_label(cast_speed_label, utility.get("cast_speed", 0))
	_set_label(magic_efficiency_label, utility.get("magic_efficiency", 0))
	if crit_chance_label:
		crit_chance_label.text = _format_percent(float(utility.get("crit_chance", 0)))
	_set_label(crit_damage_label, utility.get("crit_damage", 0))


func _set_label(label: Label, value: Variant) -> void:
	if label:
		label.text = str(value)


func _format_percent(value: float) -> String:
	return "%d%%" % int(value * 100)


func _on_mouse_enter(node: Label) -> void:
	var matching_stat := ""
	match node:
		resistance_label:
			matching_stat = "resistance"
		armour_label:
			matching_stat = "armour"
		evasion_label:
			matching_stat = "evasion"
	emit_signal("looked_at", true, {"data": node.text, "match": matching_stat})


func _on_mouse_exit() -> void:
	emit_signal("looked_at", false, {})


func _open_stat_menu(open: bool) -> void:
	var tween := get_tree().create_tween()
	if not open:
		tween.tween_property(self, "position:x", -254.0, 0.1)
	else:
		tween.tween_property(self, "position:x", 0.0, 0.1)
