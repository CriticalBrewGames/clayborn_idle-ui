extends Panel

@onready var name_label: Label = $Margin/VBox/Name
@onready var meta_label: Label = $Margin/VBox/Meta
@onready var hp_value: Label = $Margin/VBox/Stats/HP/Value
@onready var armour_value: Label = $Margin/VBox/Stats/Armour/Value
@onready var attack_value: Label = $Margin/VBox/Stats/Attack/Value
@onready var speed_value: Label = $Margin/VBox/Stats/Speed/Value
@onready var bonus_label: Label = $Margin/VBox/BonusRow/Bonus
@onready var kills_value: Label = $Margin/VBox/KillsRow/Value


func bind_entry(entry: BestiaryEntry) -> void:
	var discovered := entry.is_discovered()
	if name_label:
		name_label.text = entry.display_name if discovered else tr("BESTIARY_UNKNOWN_CREATURE")
	if meta_label:
		meta_label.text = tr("BESTIARY_META") % [entry.region, entry.level, entry.style]
	if hp_value:
		hp_value.text = str(entry.hp) if discovered else "—"
	if armour_value:
		armour_value.text = str(entry.armour) if discovered else "—"
	if attack_value:
		attack_value.text = str(entry.attack) if discovered else "—"
	if speed_value:
		speed_value.text = (tr("BESTIARY_ATTACK_SPEED_FMT") % entry.attack_speed) if discovered else "—"
	if bonus_label:
		bonus_label.text = tr("BESTIARY_DAMAGE_BONUS") % int(entry.total_damage_bonus_pct())
	if kills_value:
		kills_value.text = "%s" % _format_int(entry.kills)


func _format_int(value: int) -> String:
	var s := str(value)
	var out := ""
	var count := 0
	for i in range(s.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			out = "," + out
		out = s[i] + out
		count += 1
	return out
