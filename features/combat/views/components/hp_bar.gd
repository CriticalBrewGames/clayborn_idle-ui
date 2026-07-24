extends ProgressBar

signal current_hp_changed()

@onready var label: Label = $Indicator

@export var show_indicator: bool = true

@export_range(0, 999999, 1) var max_hp := 100:
	set(value):
		_max_hp = max(value, 1)
		max_value = _max_hp
		current_hp = clamp(current_hp, 0, _max_hp)
		call_deferred("_update_display")

	get:
		return _max_hp

@export_range(0, 999999, 1) var current_hp := 100:
	set(value):
		_current_hp = clamp(value, 0, max_hp)
		call_deferred("_update_display")
	get:
		return _current_hp

var _max_hp: int
var _current_hp: int

func _ready() -> void:
	label.visible = show_indicator
	call_deferred("_update_display")


func modify_current_hp(amount: int):
	current_hp = current_hp + amount

func change_max_hp(new_max: int, reset: bool = false):
	max_hp = new_max
	if reset:
		current_hp = max_hp


func _update_display():
	value = current_hp

	label.text = "%d / %d" % [current_hp, max_hp]
	emit_signal("current_hp_changed")


func set_non_text_label(value: String):
	label.text = value
