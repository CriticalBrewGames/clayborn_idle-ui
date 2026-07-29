extends Control

## Popup shell with Save / Load / Options content panels.
## Emits signals for Main to handle persistence; UI owns volume/font slider chrome.

signal close_pressed
signal save_requested(json_text: String)
signal load_requested(json_text: String)
signal volume_changed(linear: float)
signal font_scale_changed(scale: float)

enum ContentMode { NONE, SAVE, LOAD, OPTIONS }

const _MASTER_BUS_NAME := "Master"
const _MIN_VOLUME_DB := -80.0

@onready var title_label: Label = $TilePanel/Label
@onready var close_button: Button = $TilePanel/Button
@onready var content_host: Control = $ContentHost

var _mode: ContentMode = ContentMode.NONE
var _save_panel: Control
var _load_panel: Control
var _options_panel: Control


func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_pressed)
	_ensure_content_panels()
	show_content(ContentMode.NONE)


func show_save() -> void:
	show_content(ContentMode.SAVE)


func show_load() -> void:
	show_content(ContentMode.LOAD)


func show_options() -> void:
	show_content(ContentMode.OPTIONS)
	_sync_volume_slider()


func show_content(mode: ContentMode) -> void:
	_mode = mode
	_save_panel.visible = mode == ContentMode.SAVE
	_load_panel.visible = mode == ContentMode.LOAD
	_options_panel.visible = mode == ContentMode.OPTIONS
	match mode:
		ContentMode.SAVE:
			title_label.text = tr("POPUP_SAVE")
		ContentMode.LOAD:
			title_label.text = tr("POPUP_LOAD")
		ContentMode.OPTIONS:
			title_label.text = tr("POPUP_OPTIONS")
		_:
			title_label.text = tr("POPUP_PANEL")


func set_json_text(text: String) -> void:
	var edit := _active_text_edit()
	if edit:
		edit.text = text


func get_json_text() -> String:
	var edit := _active_text_edit()
	return edit.text if edit else ""


func _active_text_edit() -> TextEdit:
	match _mode:
		ContentMode.SAVE:
			return _save_panel.get_node_or_null("VBox/TextEdit") as TextEdit
		ContentMode.LOAD:
			return _load_panel.get_node_or_null("VBox/TextEdit") as TextEdit
		_:
			return null


func _ensure_content_panels() -> void:
	_save_panel = content_host.get_node_or_null("SavePanel")
	_load_panel = content_host.get_node_or_null("LoadPanel")
	_options_panel = content_host.get_node_or_null("OptionsPanel")
	if _save_panel:
		var btn: Button = _save_panel.get_node_or_null("VBox/ActionButton")
		if btn and not btn.pressed.is_connected(_on_save_pressed):
			btn.pressed.connect(_on_save_pressed)
	if _load_panel:
		var btn: Button = _load_panel.get_node_or_null("VBox/ActionButton")
		if btn and not btn.pressed.is_connected(_on_load_pressed):
			btn.pressed.connect(_on_load_pressed)
	if _options_panel:
		var vol: HSlider = _options_panel.get_node_or_null("VBox/VolumeRow/HSlider")
		var font_s: HSlider = _options_panel.get_node_or_null("VBox/FontRow/FontScaleSlider")
		if vol and not vol.value_changed.is_connected(_on_volume_changed):
			vol.min_value = 0.0
			vol.max_value = 100.0
			vol.step = 1.0
			vol.value_changed.connect(_on_volume_changed)
		if font_s and not font_s.value_changed.is_connected(_on_font_scale_changed):
			font_s.value_changed.connect(_on_font_scale_changed)


func _on_close_pressed() -> void:
	visible = false
	close_pressed.emit()


func _on_save_pressed() -> void:
	save_requested.emit(get_json_text())


func _on_load_pressed() -> void:
	load_requested.emit(get_json_text())


func _on_volume_changed(value: float) -> void:
	var linear := clampf(value / 100.0, 0.0, 1.0)
	_apply_master_volume_linear(linear)
	volume_changed.emit(linear)


func _on_font_scale_changed(value: float) -> void:
	font_scale_changed.emit(value)


func _sync_volume_slider() -> void:
	var vol: HSlider = _options_panel.get_node_or_null("VBox/VolumeRow/HSlider") if _options_panel else null
	if not vol:
		return
	var bus_idx := AudioServer.get_bus_index(_MASTER_BUS_NAME)
	if bus_idx < 0:
		return
	if AudioServer.is_bus_mute(bus_idx):
		vol.value = 0.0
		return
	var linear := db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
	vol.value = clampf(linear * 100.0, vol.min_value, vol.max_value)


func _apply_master_volume_linear(linear: float) -> void:
	var bus_idx := AudioServer.get_bus_index(_MASTER_BUS_NAME)
	if bus_idx < 0:
		return
	if linear <= 0.0001:
		AudioServer.set_bus_mute(bus_idx, true)
		AudioServer.set_bus_volume_db(bus_idx, _MIN_VOLUME_DB)
		return
	AudioServer.set_bus_mute(bus_idx, false)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear))
