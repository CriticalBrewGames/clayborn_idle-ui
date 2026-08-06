extends Panel

signal row_selected(entry: CharacterEntry)

@onready var portrait: ColorRect = $Margin/HBox/Portrait
@onready var name_label: Label = $Margin/HBox/NameLabel

var entry: CharacterEntry
var selected: bool = false

var _style_normal: StyleBoxFlat
var _style_selected: StyleBoxFlat


func _ready() -> void:
	_style_normal = get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	_style_selected = _style_normal.duplicate() as StyleBoxFlat
	_style_selected.bg_color = Color(0.09803922, 0.31764707, 0.42352942, 1)
	_style_selected.border_color = Color(0.145098, 0.45, 0.58, 1)
	gui_input.connect(_on_gui_input)
	_apply()


func setup(character: CharacterEntry) -> void:
	entry = character
	_apply()


func set_selected(is_selected: bool) -> void:
	selected = is_selected
	_apply_selection_visual()


func _apply() -> void:
	if name_label and entry:
		name_label.text = entry.display_label()
	_apply_selection_visual()


func _apply_selection_visual() -> void:
	if _style_normal == null or _style_selected == null:
		return
	add_theme_stylebox_override("panel", _style_selected if selected else _style_normal)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		row_selected.emit(entry)
		accept_event()
