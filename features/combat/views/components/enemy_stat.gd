extends MarginContainer
class_name EnemyStatPanel

enum DamageStyle { ATTACK, STRENGTH }
enum DefenseStyle { DEFENCE, AGILITY }

var prominent_style: StyleBox = preload(
	"res://ui/features/combat/views/components/styles/enemy_stats_panel_prominent_overwrite.tres"
)
var default_style: StyleBox = preload(
	"res://ui/features/combat/views/components/styles/enemy_stats_panel_overwrite.tres"
)

@onready var resistance_container = $VBoxContainer/HBoxContainer/ResistanceContainer
@onready var resistance_label = $VBoxContainer/HBoxContainer/ResistanceContainer/HBoxContainer/Label
@onready var defense_container = $VBoxContainer/HBoxContainer/DefenseContainer
@onready var defense_label = $VBoxContainer/HBoxContainer/DefenseContainer/HBoxContainer/Label
@onready var agility_container = $VBoxContainer/HBoxContainer/AgilityContainer
@onready var agility_label = $VBoxContainer/HBoxContainer/AgilityContainer/HBoxContainer/Label
@onready var attack_container = $VBoxContainer/HBoxContainer2/AttackContainer
@onready var attack_label = $VBoxContainer/HBoxContainer2/AttackContainer/HBoxContainer/Label
@onready var strenght_container = $VBoxContainer/HBoxContainer2/StrenghtContainer
@onready var strenght_label = $VBoxContainer/HBoxContainer2/StrenghtContainer/HBoxContainer/Label


func update_panel(
		stats: Dictionary,
		prominent_attack_style: DamageStyle,
		prominent_defensive_style: DefenseStyle
) -> void:
	var defense: Dictionary = stats.get("defense", {})
	var damage: Dictionary = stats.get("damage", {})

	resistance_label.text = str(defense.get("resistance", 0))
	defense_label.text = str(defense.get("armour", 0))
	agility_label.text = str(defense.get("evasion", 0))
	attack_label.text = str(damage.get("attack", 0))
	strenght_label.text = str(damage.get("strength", 0))

	for container in [
		attack_container,
		strenght_container,
		defense_container,
		agility_container,
		resistance_container,
	]:
		container.add_theme_stylebox_override("panel", default_style)

	match prominent_attack_style:
		DamageStyle.ATTACK:
			attack_container.add_theme_stylebox_override("panel", prominent_style)
		DamageStyle.STRENGTH:
			strenght_container.add_theme_stylebox_override("panel", prominent_style)

	match prominent_defensive_style:
		DefenseStyle.DEFENCE:
			defense_container.add_theme_stylebox_override("panel", prominent_style)
		DefenseStyle.AGILITY:
			agility_container.add_theme_stylebox_override("panel", prominent_style)
