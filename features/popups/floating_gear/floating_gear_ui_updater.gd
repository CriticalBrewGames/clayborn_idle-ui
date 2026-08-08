extends UIUpdaterBreakpoint


@onready var player_stats = $"../HBoxContainer/StatPanel"
@onready var equipment = $"../HBoxContainer/EquipmentHost"

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			player_stats.visible = false
		BreakpointsSchemas.Breakpoint.MD:
			player_stats.visible = true
