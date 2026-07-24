class_name UIUpdaterContinuous extends UIUpdaterBase

@export var min_size_delta: float = 8.0

var _last_updated_size: Vector2 = Vector2.ZERO
var _pending_size: Vector2 = Vector2.ZERO
var _is_update_queued: bool = false


func _ready() -> void:
	UiRules.viewport_size_changed.connect(_on_viewport_changed)
	
	var initial_size := Vector2(DisplayServer.window_get_size())
	_last_updated_size = initial_size
	_update_gui_dynamic(initial_size)


func _on_viewport_changed(new_size: Vector2) -> void:
	var delta := (new_size - _last_updated_size).abs()
	
	if delta.x >= min_size_delta or delta.y >= min_size_delta:
		_pending_size = new_size
		
		if not _is_update_queued:
			_is_update_queued = true
			_apply_queued_update.call_deferred()


func _apply_queued_update() -> void:
	_is_update_queued = false
	_last_updated_size = _pending_size
	_update_gui_dynamic(_pending_size)


func _update_gui_dynamic(size: Vector2) -> void:
	pass
