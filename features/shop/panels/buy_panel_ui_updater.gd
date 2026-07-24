extends UIUpdaterBreakpoint

@onready var grid: GridContainer = $"../Margin/VBox/Scroll/ShopItemGrid"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	if not is_instance_valid(grid):
		return

	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			grid.columns = 2
		BreakpointsSchemas.Breakpoint.MD:
			grid.columns = 4
		_:
			grid.columns = 6
