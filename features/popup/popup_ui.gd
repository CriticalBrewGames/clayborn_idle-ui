extends Control

signal close_pressed(scene_name: StringName)

@onready var title_label: Label = $TilePanel/Label
@onready var close_button: Button = $TilePanel/Button
@onready var content_host: Control = $ContentHost

var scene_name: StringName

func _ready() -> void:
	close_button.pressed.connect(_close_request)


func _close_request():
	close_pressed.emit(scene_name)


func inject_popup_describer(describer: PopupDescriber):
	scene_name = describer.popup_name
	_setup_visuals(
		describer.size,
		describer.position,
		describer.popup_title
	)
	
	_populate_scene(describer.content)


func _populate_scene(hosted_scene: PackedScene):
	var instance = hosted_scene.instantiate()
	add_child(instance)


func _setup_visuals(size: Vector2, position: Vector2, title: String):
	self.size = size
	self.position = position
	title_label.text = title
