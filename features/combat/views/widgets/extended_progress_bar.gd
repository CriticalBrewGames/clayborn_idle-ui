extends ProgressBar
class_name ExtendedProgressBar

signal progressbar_timout

@onready var timer_label: Label = $ProgressBarLabel
@onready var process_timer: Timer = $ProcessTimer
@onready var label_refresh: Timer = $LabelRefreshTimer

@export var one_shot: bool = false
@export var freeze_on_finish: bool = false

var _process_time: float = 0

var process_time: float:
	set(value):
		_process_time = value
		if is_inside_tree():
			_re_evaluate_process_time(value)
	get:
		return _process_time

var time_left: float:
	get:
		return process_timer.get_time_left()


func _ready() -> void:
	label_refresh.timeout.connect(_on_label_refresh_timer_timeout)
	process_timer.timeout.connect(_on_process_timer_timeout)


func _re_evaluate_process_time(new_time: float) -> void:
	var was_running := not process_timer.is_stopped()
	var progress_ratio := 0.0
	if was_running and max_value > 0:
		var elapsed := max_value - process_timer.time_left
		progress_ratio = elapsed / max_value
	max_value = new_time
	timer_label.text = TimeUtils.time_conversion(new_time)
	process_timer.wait_time = new_time
	if was_running:
		var new_remaining := new_time * (1.0 - progress_ratio)
		process_timer.stop()
		process_timer.wait_time = maxf(new_remaining, 0.01)
		process_timer.start()
		value = new_time * progress_ratio
		_sample_timer(process_timer.time_left)


func start_progressbar() -> void:
	value = 0
	process_timer.stop()
	label_refresh.stop()
	process_timer.wait_time = _process_time
	process_timer.start()
	label_refresh.start()
	_sample_timer(process_timer.get_time_left())


func reset_progressbar() -> void:
	value = 0
	process_timer.stop()
	label_refresh.stop()
	timer_label.text = TimeUtils.time_conversion(process_time)


func pause_progressbar() -> void:
	process_timer.paused = true
	label_refresh.stop()


func _sample_timer(timer_time: float) -> void:
	value = max_value - timer_time
	timer_label.text = TimeUtils.time_conversion(timer_time, max_value)


func _on_label_refresh_timer_timeout() -> void:
	if not process_timer.is_stopped():
		_sample_timer(process_timer.get_time_left())
	else:
		label_refresh.stop()


func _on_process_timer_timeout() -> void:
	progressbar_timout.emit()
	if freeze_on_finish:
		pause_progressbar()
		return
	if one_shot:
		pause_progressbar()
		reset_progressbar()
