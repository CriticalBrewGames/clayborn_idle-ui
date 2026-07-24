extends UIUpdaterBreakpoint

const HEIGHT_SM: float = 170.0
const HEIGHT_MD: float = 190.0
const HEIGHT_LG: float = 210.0

@onready var root: Control = $".."


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			UIUpdaterBase.update_min_max_size_y(root, HEIGHT_SM)
		BreakpointsSchemas.Breakpoint.MD:
			UIUpdaterBase.update_min_max_size_y(root, HEIGHT_MD)
		BreakpointsSchemas.Breakpoint.LG:
			UIUpdaterBase.update_min_max_size_y(root, HEIGHT_LG)
		_:
			UIUpdaterBase.update_min_max_size_y(root, HEIGHT_MD)
