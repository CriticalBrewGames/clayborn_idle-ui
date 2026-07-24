extends UIUpdaterBreakpoint

@onready var root: Control = $".."
@onready var skill_filters: Control = $"../Margin/VBox/SkillFilters"
@onready var chapter_row: Control = $"../Margin/VBox/ChapterRow"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			skill_filters.visible = false
			chapter_row.visible = true
			root.custom_minimum_size.y = 90
			root.custom_maximum_size.y = 120
		_:
			skill_filters.visible = true
			chapter_row.visible = true
			root.custom_minimum_size.y = 130
			root.custom_maximum_size.y = 190
