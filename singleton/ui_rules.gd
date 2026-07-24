class_name UIRules extends Node

signal breakpoint_changed(new_breakpoint: BreakpointsSchemas.Breakpoint)
signal viewport_size_changed(new_size: Vector2)

var current_breakpoint: BreakpointsSchemas.Breakpoint


static func get_current_breakpoint(current_size: Vector2) -> BreakpointsSchemas.Breakpoint:
	for breakpoint_name in BreakpointsSchemas.BREAKPOINTS:
		if current_size.y <= BreakpointsSchemas.BREAKPOINTS[breakpoint_name]:
			return breakpoint_name
			
	return BreakpointsSchemas.Breakpoint.XXL


func _init() -> void:
	current_breakpoint = get_current_breakpoint(DisplayServer.window_get_size())


func _ready() -> void:
	get_tree().root.size_changed.connect(on_viewport_size_changed)

func on_viewport_size_changed() -> void:
	var new_size := Vector2(DisplayServer.window_get_size())
	
	viewport_size_changed.emit(new_size)
	
	var new_bp = get_current_breakpoint(new_size)
	if new_bp != current_breakpoint:
		current_breakpoint = new_bp
		breakpoint_changed.emit(current_breakpoint)
