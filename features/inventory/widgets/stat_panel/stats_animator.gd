extends Control

const OPENED_POS: Vector2 = Vector2(-250, 0)

@onready var close_button: Button = $Control/Button
@onready var stat_panel: Control = $Control

var closed_pos: Vector2

var state: String = "closed":
	set(value):
		if value == "closed" and close_button:
			close_button.text = "<"
		elif value == "open" and close_button:
			close_button.text = ">"
		_state = value

var _state: String = "closed"


func _ready() -> void:
	closed_pos = stat_panel.position


func _on_button_pressed() -> void:
	match _state:
		"closed":
			_open_anim()
			state = "open"
		"open":
			_close_anim()
			state = "closed"


func _open_anim() -> void:
	var tween := create_tween()
	tween.parallel().tween_property(stat_panel, "position", closed_pos + OPENED_POS, 0.05)


func _close_anim() -> void:
	var tween := create_tween()
	tween.parallel().tween_property(stat_panel, "position", closed_pos, 0.05)
