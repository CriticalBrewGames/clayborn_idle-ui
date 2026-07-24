extends Control

const EnemyStat := preload("res://ui/features/combat/views/components/enemy_stat.gd")

@onready var _player_hp: ProgressBar = $Panel/VBoxContainer/HpBars/PlayerHp
@onready var _enemy_hp: ProgressBar = $Panel/VBoxContainer/HpBars/EnemyHp
@onready var _enemy_stats: EnemyStat = $Panel/VBoxContainer/EnemyStatsPanel


func _ready() -> void:
	if _player_hp.has_method("change_max_hp"):
		_player_hp.change_max_hp(120, true)
	if _enemy_hp.has_method("change_max_hp"):
		_enemy_hp.change_max_hp(80, true)
		_enemy_hp.modify_current_hp(-20)

	_enemy_stats.update_panel(
		{
			"defense": {"resistance": 5, "armour": 12, "evasion": 3},
			"damage": {"attack": 8, "strength": 4},
		},
		EnemyStat.DamageStyle.ATTACK,
		EnemyStat.DefenseStyle.DEFENCE
	)
