extends UIUpdaterBreakpoint


@onready var enemy_stat_panel_minimal: Control = $"../EnemyStatMinimalPanel"

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			enemy_stat_panel_minimal.visible = true
		BreakpointsSchemas.Breakpoint.MD:
			enemy_stat_panel_minimal.visible = false
