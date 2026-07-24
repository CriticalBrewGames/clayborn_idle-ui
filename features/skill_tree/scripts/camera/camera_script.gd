extends Camera2D

const MAX_ZOOM: Vector2 = Vector2(1.5, 1.5)
const MIN_ZOOM: Vector2 = Vector2(0.5, 0.5)
const ZOOM_STEP_SIZE: Vector2 = Vector2(0.02, 0.02)
const EDGE_SCROLL_DEADZONE = 0.05
const EDGE_SCROLL_DRAG_SENSITIVITY: float = 1000.0
const DRAG_SENSITIVITY: float = 1.0

@export var start_position: Vector2
@export var camera_bounds: Array[Vector2] = []


func _unhandled_input(_event: InputEvent) -> void:
	_camera_zoom()
	_drag_camera()


func _camera_zoom() -> void:
	if Input.is_action_just_pressed("zoom_out"):
		if zoom <= MAX_ZOOM:
			zoom += ZOOM_STEP_SIZE
	if Input.is_action_just_pressed("zoom_in"):
		if zoom >= MIN_ZOOM:
			zoom -= ZOOM_STEP_SIZE


func _drag_camera() -> void:
	if Input.is_action_just_pressed("camera_drag"):
		start_position = get_global_mouse_position()
	elif Input.is_action_just_released("camera_drag"):
		start_position = Vector2.ZERO
	elif Input.is_action_pressed("camera_drag") and start_position != Vector2.ZERO:
		var mouse_position = get_global_mouse_position()
		var difference = start_position - mouse_position
		_camera_move(difference)


func _camera_move(direction: Vector2, optional_drag_force: float = 1.0) -> void:
	global_position += direction * DRAG_SENSITIVITY * optional_drag_force
	_clamp_camera()


func _clamp_camera() -> void:
	if camera_bounds.size() < 2:
		return
	global_position.x = clamp(global_position.x, camera_bounds[0].x, camera_bounds[1].x)
	global_position.y = clamp(global_position.y, camera_bounds[0].y, camera_bounds[1].y)
