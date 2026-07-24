extends UIUpdaterBreakpoint

@onready var root: Control = $".."
@onready var box_container: Control = $"../UtilityButtonBoxContainer"
@onready var grid_container: Control = $"../UtilityButtonGridContainer"

var buttons: Array[Button] = []

func _ready() -> void:
	super._ready()
	
	# Fetch all buttons under root initially
	var found_nodes = root.find_children("*", "Button", true, false)
	for node in found_nodes:
		if node is Button:
			buttons.append(node)


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			_move_buttons_to(grid_container)
			UIUpdaterBase.nullify_size(root)
		_:
			_move_buttons_to(box_container)
			UIUpdaterBase.nullify_size(root)


func _move_buttons_to(target_container: Control) -> void:
	if not is_instance_valid(target_container):
		return
		
	for button in buttons:
		# Guard against null references and unnecessary reparenting
		if is_instance_valid(button) and button.get_parent() != target_container:
			# reparent automatically removes from old parent and adds to new parent
			button.reparent(target_container)
