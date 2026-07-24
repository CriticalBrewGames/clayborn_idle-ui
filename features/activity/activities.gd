extends Panel

## Activity tracker binding surface. Main calls set_activity / clear_activity.

signal activity_set(type: String, label: String, progress: float)
signal activity_cleared(type: String)

@onready var label: Label = $HBoxContainer/VBoxContainer/Label
@onready var progress_bar: ProgressBar = $HBoxContainer/VBoxContainer/ProgressBar
@onready var panel_icon: TextureRect = $HBoxContainer/Panel/TextureRect
@onready var radial: Control = $RadialProgress
@onready var radial_icon: TextureRect = $RadialProgress/Panel/TextureRect

## type -> { label, progress, icon }
var _activities: Dictionary = {}
var _active_type: String = ""


func set_activity(type: String, activity_label: String, progress: float) -> void:
	var existing: Dictionary = _activities.get(type, {})
	existing["label"] = activity_label
	existing["progress"] = clampf(progress, 0.0, 1.0)
	_activities[type] = existing
	_active_type = type
	_apply_display(type)
	activity_set.emit(type, activity_label, progress)


func set_activity_icon(type: String, texture: Texture2D) -> void:
	if not _activities.has(type):
		_activities[type] = {"label": "", "progress": 0.0}
	_activities[type]["icon"] = texture
	if _active_type == type:
		_apply_icon(texture)


func clear_activity(type: String) -> void:
	_activities.erase(type)
	if _active_type == type:
		_active_type = ""
		if label:
			label.text = ""
		if progress_bar:
			progress_bar.value = 0.0
		_apply_icon(null)
		if not _activities.is_empty():
			var next_type: String = str(_activities.keys()[0])
			_active_type = next_type
			_apply_display(next_type)
	activity_cleared.emit(type)


func get_activity(type: String) -> Dictionary:
	return _activities.get(type, {})


func _apply_display(type: String) -> void:
	var data: Dictionary = _activities.get(type, {})
	if label:
		label.text = str(data.get("label", ""))
	if progress_bar:
		progress_bar.max_value = 1.0
		progress_bar.value = float(data.get("progress", 0.0))
	if radial and "progress" in radial:
		radial.progress = float(data.get("progress", 0.0)) * 100.0
	if data.get("icon") is Texture2D:
		_apply_icon(data["icon"])


func _apply_icon(texture: Texture2D) -> void:
	if panel_icon:
		panel_icon.texture = texture
	if radial_icon:
		radial_icon.texture = texture
