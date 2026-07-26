extends UIUpdaterBreakpoint

@onready var _stats_button: Control = $"../StatsButton"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	if not _stats_button:
		return
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			_stats_button.visible = true
		BreakpointsSchemas.Breakpoint.MD:
			_stats_button.visible = false
		_:
			_stats_button.visible = false
