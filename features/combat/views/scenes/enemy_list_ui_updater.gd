extends UIUpdaterBreakpoint

const ROOT_SM_SIZE = Vector2(1000, 160)
const ROOT_MD_SIZE = Vector2(1000, 350)

@onready var root: Control = $".."


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			root.set_size(ROOT_SM_SIZE)
		BreakpointsSchemas.Breakpoint.MD:
			root.set_size(ROOT_MD_SIZE)
