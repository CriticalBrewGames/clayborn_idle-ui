extends UIUpdaterBreakpoint

const ROOT_CONTAINER_SM: Vector2 = Vector2(90, 140)
const ROOT_CONTAINER_MD: Vector2 = Vector2(140, 75)

@onready var root = $".."
@onready var timer_container = $"../BoxContainer3"

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			root.custom_minimum_size = ROOT_CONTAINER_SM
			root.set_size(ROOT_CONTAINER_SM)
			timer_container.vertical = false
			
		BreakpointsSchemas.Breakpoint.MD:
			root.custom_minimum_size = ROOT_CONTAINER_MD
			root.set_size(ROOT_CONTAINER_MD)
			timer_container.vertical = true
