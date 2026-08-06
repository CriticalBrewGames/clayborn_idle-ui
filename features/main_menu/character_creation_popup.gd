extends Control

signal character_created(entry: CharacterEntry)
signal cancelled

const HARDCORE_HINT := "Cooldown on eating, cannot escape from monsters"

@onready var dimmer: ColorRect = $Dimmer
@onready var name_edit: LineEdit = $Center/Panel/Margin/VBox/NameRow/NameEdit
@onready var softcore_button: CheckBox = $Center/Panel/Margin/VBox/ModeColumn/Softcore
@onready var hardcore_button: CheckBox = $Center/Panel/Margin/VBox/ModeColumn/Hardcore
@onready var hardcore_hint: Label = $Center/Panel/Margin/VBox/ModeColumn/HardcoreHintMargin/HardcoreHint
@onready var create_button: Button = $Center/Actions/CreateButton
@onready var cancel_button: Button = $Center/Actions/CancelButton

var _mode_group: ButtonGroup


func _ready() -> void:
	_mode_group = ButtonGroup.new()
	softcore_button.button_group = _mode_group
	hardcore_button.button_group = _mode_group
	softcore_button.button_pressed = true

	hardcore_hint.text = HARDCORE_HINT
	create_button.pressed.connect(_on_create_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	dimmer.gui_input.connect(_on_dimmer_input)
	name_edit.text_changed.connect(_on_name_changed)
	_refresh_create_enabled()
	visible = false


func open_popup() -> void:
	name_edit.text = ""
	softcore_button.button_pressed = true
	_refresh_create_enabled()
	visible = true
	name_edit.grab_focus()


func close_popup() -> void:
	visible = false


func _selected_mode() -> CharacterEntry.GameMode:
	if hardcore_button.button_pressed:
		return CharacterEntry.GameMode.HARDCORE
	return CharacterEntry.GameMode.SOFTCORE


func _refresh_create_enabled() -> void:
	create_button.disabled = name_edit.text.strip_edges().is_empty()


func _on_name_changed(_new_text: String) -> void:
	_refresh_create_enabled()


func _on_create_pressed() -> void:
	var trimmed := name_edit.text.strip_edges()
	if trimmed.is_empty():
		return

	var entry := CharacterEntry.new()
	entry.id = StringName("char_%d" % Time.get_ticks_msec())
	entry.character_name = trimmed
	entry.mode = _selected_mode()

	character_created.emit(entry)
	close_popup()


func _on_cancel_pressed() -> void:
	close_popup()
	cancelled.emit()


func _on_dimmer_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		_on_cancel_pressed()
		accept_event()
