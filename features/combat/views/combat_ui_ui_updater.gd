extends UIUpdaterBreakpoint


@onready var enemy_stat_panel_minimal: Control = $"../EnemyStatMinimalPanel"
@onready var enemy_stats_full: Control = $"../ArenaPanel/MarginContainer/MainRow/EnemyColumn/EnemyContainer/EnemyStatsPanel"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			enemy_stat_panel_minimal.visible = true
			if enemy_stats_full:
				enemy_stats_full.visible = false
		BreakpointsSchemas.Breakpoint.MD:
			enemy_stat_panel_minimal.visible = false
			if enemy_stats_full:
				enemy_stats_full.visible = true
