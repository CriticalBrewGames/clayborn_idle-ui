extends UIUpdaterBreakpoint


const ROOT_MINIMAL_SIZE = Vector2(120, 180)
const ROOT_MAXIMUM_SZE =  Vector2(55, 310)

@onready var root: Control = $".."
@onready var skill_box_container: BoxContainer = $"../Panel/SkillBoxContainer"

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.MD:
			skill_box_container.vertical = false
			UIUpdaterBase.update_min_max_size(root, ROOT_MINIMAL_SIZE)
			#skill_box_container.size = ROOT_MINIMAL_SIZE
		BreakpointsSchemas.Breakpoint.LG:
			skill_box_container.vertical = true
			UIUpdaterBase.update_min_max_size(root, ROOT_MAXIMUM_SZE)
			#skill_box_container.size = ROOT_MAXIMUM_SZE
