extends UIUpdaterBreakpoint

@onready var main_theme: Theme = preload("res://ui/assets/theme_test.tres")

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	main_theme.set_font_size("font_size", "Label", ScaleRuleBook.DEFAULT_FONT_SCALES[new_breakpoint])
