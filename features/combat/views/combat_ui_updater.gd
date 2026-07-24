extends UIUpdaterBreakpoint

const ROOT_SM_SIZE = Vector2(300, 500)
const ROOT_MD_SIZE = Vector2(920, 780)

@onready var root = $".."

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			root.set_size(ROOT_SM_SIZE)
		BreakpointsSchemas.Breakpoint.MD:
			root.set_size(ROOT_MD_SIZE)
