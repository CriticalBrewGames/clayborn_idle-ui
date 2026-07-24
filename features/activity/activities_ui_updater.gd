extends UIUpdaterBreakpoint

const MINIMAL_SIZE: Vector2 = Vector2(60, 60)
const MAXIMUM_SIZE: Vector2 = Vector2(200, 60)

@onready var root: Control = $".."
@onready var minimal_activities: Control = $"../RadialProgress"
@onready var maximum_activities: Control = $"../HBoxContainer"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			minimal_activities.visible = true
			maximum_activities.visible = false
			
			UIUpdaterBase.update_min_max_size(root, MINIMAL_SIZE)
		BreakpointsSchemas.Breakpoint.MD:
			minimal_activities.visible = false
			maximum_activities.visible = true
			
			UIUpdaterBase.update_min_max_size(root, MAXIMUM_SIZE)
