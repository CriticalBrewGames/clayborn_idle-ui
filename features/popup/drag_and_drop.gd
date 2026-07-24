class_name DragAndDrop extends Node

@export var grabbable: Control # Node which activates the grab when held
@export var moveable: Control  # Node to move (usually your main Window/Panel)

var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not grabbable or not moveable:
		push_warning("DragAndDrop: Ensure both 'grabbable' and 'moveable' are assigned in the Inspector.")
		return
	
	# Connect the gui_input signal on the handle automatically
	grabbable.gui_input.connect(_on_grabbable_gui_input)

func _on_grabbable_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_is_dragging = true
			# Calculate offset between mouse position and moveable's top-left origin
			_drag_offset = moveable.global_position - moveable.get_global_mouse_position()
		else:
			_is_dragging = false

func _input(event: InputEvent) -> void:
	# Handles moving and releases if the mouse releases outside the handle bounds
	if event is InputEventMouseMotion and _is_dragging:
		moveable.global_position = moveable.get_global_mouse_position() + _drag_offset
		
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_is_dragging = false
