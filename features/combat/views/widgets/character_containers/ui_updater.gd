extends UIUpdaterBreakpoint

@onready var root_node = $".."
@onready var combat_style = $"../CombatStyleWidget"

const ROOT_SM_SIZE = Vector2(150, 400)
const ROOT_MD_SIZE = Vector2(200, 500)

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		
		BreakpointsSchemas.Breakpoint.SM:
			print(root_node)
			root_node.set_size(ROOT_SM_SIZE)
			root_node.custom_minimum_size = ROOT_SM_SIZE
			combat_style.visible = false
			combat_style.size_flags_vertical = Control.SIZE_FILL
		BreakpointsSchemas.Breakpoint.MD:
			print(root_node)
			root_node.set_size(ROOT_MD_SIZE, true)
			root_node.custom_minimum_size = ROOT_MD_SIZE
			combat_style.visible = true
			combat_style.size_flags_vertical = Control.SIZE_EXPAND_FILL
