extends Panel

signal selected(entry_id: String)

@export var entry_id: String = ""
@export var display_name: String = "BESTIARY_UNKNOWN"
@export var level: int = 1
@export var discovered: bool = false
@export var is_selected: bool = false
@export var sprite: Texture2D

@onready var art: TextureRect = $Margin/VBox/ArtFrame/Art
@onready var placeholder: Label = $Margin/VBox/ArtFrame/Placeholder
@onready var name_label: Label = $Margin/VBox/Name
@onready var level_label: Label = $Margin/VBox/Level
@onready var button: Button = $SelectButton

var _style_normal: StyleBoxFlat
var _style_selected: StyleBoxFlat


func _ready() -> void:
	_style_normal = StyleBoxFlat.new()
	_style_normal.bg_color = Color(0.105882354, 0.1764706, 0.23137255, 1)
	_style_normal.set_border_width_all(1)
	_style_normal.border_color = Color(0.06666667, 0.12156863, 0.16470589, 1)
	_style_normal.set_corner_radius_all(10)

	_style_selected = _style_normal.duplicate() as StyleBoxFlat
	_style_selected.border_color = Color(0.35, 0.72, 0.95, 1)
	_style_selected.set_border_width_all(3)

	if button:
		button.pressed.connect(_on_pressed)
	_apply()


func setup(entry: BestiaryEntry, selected_now: bool) -> void:
	entry_id = entry.id
	display_name = entry.display_name
	level = entry.level
	discovered = entry.is_discovered()
	sprite = entry.sprite
	is_selected = selected_now
	_apply()


func set_selected(value: bool) -> void:
	is_selected = value
	_apply_selection()


func _apply() -> void:
	if name_label:
		name_label.text = display_name if discovered else tr("BESTIARY_UNKNOWN")
	if level_label:
		level_label.text = tr("BESTIARY_LEVEL") % level
	if art:
		art.texture = sprite if discovered else null
		art.visible = discovered and sprite != null
	if placeholder:
		placeholder.visible = not (discovered and sprite != null)
		placeholder.text = "?" if not discovered else "art"
	modulate.a = 1.0 if discovered else 0.55
	_apply_selection()


func _apply_selection() -> void:
	if _style_selected == null or _style_normal == null:
		return
	add_theme_stylebox_override("panel", _style_selected if is_selected else _style_normal)


func _on_pressed() -> void:
	selected.emit(entry_id)
