extends UIUpdaterBreakpoint

@onready var main_row: GridContainer = $"../VBoxContainer/BestiaryMain"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	if main_row == null:
		return
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			main_row.columns = 1
		_:
			main_row.columns = 2
