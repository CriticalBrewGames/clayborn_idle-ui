extends Panel

@onready var count_label: Label = $Margin/VBox/Header/Count
@onready var entries_box: VBoxContainer = $Margin/VBox/Scroll/Entries
@onready var empty_label: Label = $Margin/VBox/Scroll/Entries/EmptyHint
@onready var locked_label: Label = $Margin/VBox/LockedHint

var _entry_style: StyleBoxFlat


func _ready() -> void:
	_entry_style = StyleBoxFlat.new()
	_entry_style.bg_color = Color(0.06666667, 0.12156863, 0.16470589, 1)
	_entry_style.set_corner_radius_all(8)
	_entry_style.content_margin_left = 10
	_entry_style.content_margin_top = 8
	_entry_style.content_margin_right = 10
	_entry_style.content_margin_bottom = 8


func bind_entry(entry: BestiaryEntry) -> void:
	var unlocked := entry.unlocked_milestones()
	var next := entry.next_milestone()

	if count_label:
		count_label.text = "%d / %d entries" % [unlocked.size(), entry.milestones.size()]

	for child in entries_box.get_children():
		if child == empty_label:
			continue
		child.queue_free()

	if empty_label:
		empty_label.visible = unlocked.is_empty()

	for milestone in unlocked:
		entries_box.add_child(_make_lore_card(milestone))

	if locked_label:
		if next:
			var remaining: int = next.kills - entry.kills
			locked_label.visible = true
			locked_label.text = "Locked · %s — %d more kills · +%d%% damage" % [
				next.label,
				remaining,
				int(next.damage_bonus_pct),
			]
		else:
			locked_label.visible = false


func _make_lore_card(milestone: BestiaryMilestone) -> PanelContainer:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _entry_style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	card.add_child(vbox)

	var header := HBoxContainer.new()
	vbox.add_child(header)

	var title := Label.new()
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.text = milestone.label
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.95, 0.97, 0.98, 1))
	header.add_child(title)

	var meta := Label.new()
	meta.text = "%d kills · +%d%%" % [milestone.kills, int(milestone.damage_bonus_pct)]
	meta.add_theme_font_size_override("font_size", 11)
	meta.add_theme_color_override("font_color", Color(0.7, 0.78, 0.84, 1))
	header.add_child(meta)

	var body := Label.new()
	body.text = milestone.lore
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 12)
	body.add_theme_color_override("font_color", Color(0.8, 0.86, 0.9, 1))
	vbox.add_child(body)

	return card
