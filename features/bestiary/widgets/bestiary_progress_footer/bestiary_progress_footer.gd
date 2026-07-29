extends Panel

@onready var next_label: Label = $Margin/VBox/Header/NextLabel
@onready var progress_bar: ProgressBar = $Margin/VBox/ProgressBar
@onready var mastery_label: Label = $Margin/VBox/MasteryRow/Mastery
@onready var pct_label: Label = $Margin/VBox/MasteryRow/Pct
@onready var markers: Control = $Margin/VBox/Markers
@onready var pills: HBoxContainer = $Margin/VBox/PillsScroll/Pills

var _bound_entry: BestiaryEntry
var _marker_nodes: Array[Control] = []


func _ready() -> void:
	if markers:
		markers.resized.connect(_place_markers)


func bind_entry(entry: BestiaryEntry) -> void:
	_bound_entry = entry
	var progress: Dictionary = entry.progress_to_next()
	var cap: int = entry.mastery_kill_cap()
	var fill: int = mini(entry.kills, cap)

	if next_label:
		next_label.text = str(progress.get("label", ""))

	if progress_bar:
		progress_bar.max_value = float(cap)
		progress_bar.value = float(fill)

	if mastery_label:
		mastery_label.text = tr("BESTIARY_TOWARD_MASTERY") % [_format_int(fill), _format_int(cap)]

	if pct_label:
		pct_label.text = tr("BESTIARY_PCT_TO_NEXT") % int(progress.get("pct", 0.0))

	_rebuild_markers(entry)
	_rebuild_pills(entry)
	call_deferred("_place_markers")


func _rebuild_markers(entry: BestiaryEntry) -> void:
	for node in _marker_nodes:
		if is_instance_valid(node):
			node.queue_free()
	_marker_nodes.clear()

	if markers == null:
		return

	for milestone in entry.milestones:
		var unlocked := entry.kills >= milestone.kills
		var marker := VBoxContainer.new()
		marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		marker.alignment = BoxContainer.ALIGNMENT_CENTER
		marker.add_theme_constant_override("separation", 2)

		var tick := ColorRect.new()
		tick.custom_minimum_size = Vector2(10, 10)
		tick.color = Color(0.35, 0.72, 0.95, 1) if unlocked else Color(0.2, 0.28, 0.34, 1)
		marker.add_child(tick)

		var label := Label.new()
		label.text = str(milestone.kills)
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override(
			"font_color",
			Color(0.8, 0.86, 0.9, 1) if unlocked else Color(0.55, 0.62, 0.68, 1)
		)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		marker.add_child(label)

		markers.add_child(marker)
		_marker_nodes.append(marker)


func _place_markers() -> void:
	if markers == null or _bound_entry == null:
		return
	var cap: int = _bound_entry.mastery_kill_cap()
	if cap <= 0:
		return
	var width := markers.size.x
	if width <= 1.0:
		return
	for i in range(mini(_marker_nodes.size(), _bound_entry.milestones.size())):
		var milestone: BestiaryMilestone = _bound_entry.milestones[i]
		var marker: Control = _marker_nodes[i]
		var ratio := clampf(float(milestone.kills) / float(cap), 0.0, 0.98)
		marker.position = Vector2(width * ratio - 12.0, 0.0)


func _rebuild_pills(entry: BestiaryEntry) -> void:
	for child in pills.get_children():
		child.queue_free()

	for milestone in entry.milestones:
		var unlocked := entry.kills >= milestone.kills
		var pill := Button.new()
		pill.toggle_mode = true
		pill.button_pressed = unlocked
		pill.disabled = true
		pill.focus_mode = Control.FOCUS_NONE
		if unlocked:
			pill.text = tr("BESTIARY_MILESTONE_PILL") % [
				milestone.kills,
				milestone.label,
				int(milestone.damage_bonus_pct),
			]
		else:
			pill.text = tr("BESTIARY_MILESTONE_PILL_SHORT") % [milestone.kills, milestone.label]
		pills.add_child(pill)


func _format_int(value: int) -> String:
	var s := str(value)
	var out := ""
	var count := 0
	for i in range(s.length() - 1, -1, -1):
		if count > 0 and count % 3 == 0:
			out = "," + out
		out = s[i] + out
		count += 1
	return out
