extends HBoxContainer

signal mode_changed(mode: StringName)

const MODE_TRAVEL := &"travel"
const MODE_HANGAR := &"hangar"

@onready var travel_btn: Button = $TravelBtn
@onready var hangar_btn: Button = $HangarBtn


func _ready() -> void:
	travel_btn.toggled.connect(_on_toggled.bind(MODE_TRAVEL))
	hangar_btn.toggled.connect(_on_toggled.bind(MODE_HANGAR))

	if travel_btn.button_pressed:
		mode_changed.emit(MODE_TRAVEL)
	elif hangar_btn.button_pressed:
		mode_changed.emit(MODE_HANGAR)


func _on_toggled(pressed: bool, mode: StringName) -> void:
	if pressed:
		mode_changed.emit(mode)
