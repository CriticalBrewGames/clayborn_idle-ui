class_name UIUpdaterBreakpoint extends UIUpdaterBase


func _ready() -> void:
	UiRules.breakpoint_changed.connect(_on_breakpoint_changed)
	_update_gui_bp(UiRules.current_breakpoint)


func _on_breakpoint_changed(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	_update_gui_bp(new_breakpoint)


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	pass
