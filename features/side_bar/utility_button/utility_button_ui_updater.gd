extends UIUpdaterBreakpoint

const MAXIMUM_SIZE: Vector2 = Vector2(125, 35)
const MINIMUM_SIZE: Vector2 = Vector2(45, 45)

@onready var root: Button = $".."
@onready var label: Label = $"../Label"
@onready var icon: TextureRect = $"../IconText"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			UIUpdaterBase.update_min_max_size(root, MINIMUM_SIZE)
			label.visible = false
			
			icon.set_anchors_preset(Control.PRESET_CENTER)
			icon.position = Vector2(8.5, 8.5)
		
		BreakpointsSchemas.Breakpoint.MD:
			UIUpdaterBase.update_min_max_size(root, MAXIMUM_SIZE)
			label.visible = true
			
			icon.set_anchors_preset(Control.PRESET_CENTER_LEFT)
			icon.position = Vector2(4, 3.5)
