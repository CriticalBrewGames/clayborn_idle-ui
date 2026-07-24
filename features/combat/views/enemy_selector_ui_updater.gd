extends UIUpdaterBreakpoint

const MAXIMUM_HEIGHT: float = 190
const MINIMUM_HEIGHT: float = 110

@onready var root: Control = $".."

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.MD:
			UIUpdaterBase.update_min_max_size_y(root, MINIMUM_HEIGHT)
		BreakpointsSchemas.Breakpoint.LG:
			UIUpdaterBase.update_min_max_size_y(root, MAXIMUM_HEIGHT)
