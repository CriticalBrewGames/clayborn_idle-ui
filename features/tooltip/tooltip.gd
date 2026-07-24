extends PanelContainer

## Mouse-follow tooltip with delayed fade-in. Content is filled by the consumer
## (connect to `toggle_on` / set child labels before calling `toggle`).

signal toggle_on(extra_args: Dictionary)
signal toggle_off

const DELAY_TIME: float = 0.5

@export var offset: Vector2 = Vector2(5, 25)

var opacity_tween: Tween = null
var original_scale: Vector2 = Vector2.ZERO
var _should_show := false


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + offset


func _ready() -> void:
	original_scale = scale
	scale = Vector2.ZERO
	hide()


func toggle(on: bool, extra_args: Dictionary = {}) -> void:
	_should_show = on

	if on:
		emit_signal("toggle_on", extra_args)
		await get_tree().create_timer(DELAY_TIME).timeout
		if not _should_show:
			return
		global_position = get_global_mouse_position() + offset
		show()
		modulate.a = 0.0
		_tween_opacity(1.0, original_scale)
	else:
		emit_signal("toggle_off")
		modulate.a = 1.0
		await _tween_opacity(0.0, Vector2.ZERO).finished
		hide()


func _tween_opacity(to: float, scale_to: Vector2) -> Tween:
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.set_parallel()
	opacity_tween.tween_property(self, "scale", scale_to, 0.05)
	opacity_tween.tween_property(self, "modulate:a", to, 0.02)
	return opacity_tween
