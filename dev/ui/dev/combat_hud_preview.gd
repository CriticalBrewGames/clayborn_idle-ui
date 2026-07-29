extends Control

const _EnemyStat := preload("res://ui/features/combat/views/components/enemy_stat.gd")

@onready var _hud: CombatHudView = $CombatScene/VBoxContainer/CombatUi/CombatHudView
@onready var _enemy_list = $CombatScene/VBoxContainer/EnemyList


func _ready() -> void:
	_populate_enemy_list()
	_hud.set_player_hp(95, 120)
	_hud.set_enemy_hp(60, 80)
	_hud.set_player_attack_speed(2.4)
	_hud.set_enemy_attack_speed(3.1)
	_hud.set_enemy_display(
		"Forest Bug",
		preload("res://assets/monsters/forrest/forest_bug.webp"),
		{
			"defense": {"resistance": 5, "armour": 12, "evasion": 3},
			"damage": {"attack": 8, "strength": 4},
		},
		_EnemyStat.DamageStyle.ATTACK,
		_EnemyStat.DefenseStyle.DEFENCE
	)

	var offensive_grid = $CombatScene/VBoxContainer/CombatUi/ArenaPanel/MarginContainer/MainRow/PlayerColumn/PlayerContainer/CombatStyleWidget/Panel/CombatStyleGrid/Offensive
	var defensive_grid = $CombatScene/VBoxContainer/CombatUi/ArenaPanel/MarginContainer/MainRow/PlayerColumn/PlayerContainer/CombatStyleWidget/Panel/CombatStyleGrid/Defensive
	_hud.bind_style_grids(offensive_grid, defensive_grid)


func _populate_enemy_list() -> void:
	if not _enemy_list.has_method("populate"):
		return
	_enemy_list.populate([
		{
			"id": "forest_bug",
			"name": "Forest Bug",
			"level": 3,
			"sprite": preload("res://assets/monsters/forrest/forest_bug.webp"),
		},
		{
			"id": "moss_golem",
			"name": "Moss Golem",
			"level": 8,
			"sprite": preload("res://assets/monsters/forrest/moss_golem.webp"),
		},
		{
			"id": "treant_sapling",
			"name": "Treant Sapling",
			"level": 12,
			"sprite": preload("res://assets/monsters/forrest/treant_sapling.webp"),
			"locked": true,
		},
		{
			"id": "mine_rat",
			"name": "Mine Rat",
			"level": 5,
			"sprite": preload("res://assets/monsters/mine/rat.webp"),
		},
		{
			"id": "sea_serpent",
			"name": "Sea Serpent",
			"level": 20,
			"sprite": preload("res://assets/monsters/sea/sea_serpent.webp"),
			"locked": true,
		},
	])
