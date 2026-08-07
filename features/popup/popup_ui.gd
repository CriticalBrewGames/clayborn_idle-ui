class_name PopupUi extends Control

signal close_pressed(scene_name: StringName)

@onready var title_label: Label = $TilePanel/Label
@onready var close_button: Button = $TilePanel/Button
@onready var content_host: Control = $ContentHost

var scene_name: StringName
var _content: Control


func _ready() -> void:
	close_button.pressed.connect(_close_request)


func _close_request():
	visible = false
	close_pressed.emit(scene_name)


## Window chrome only (title / size / position). Content is mounted separately.
func apply_describer(describer: PopupDescriber) -> void:
	scene_name = describer.popup_name
	_setup_visuals(
		describer.size,
		describer.position,
		describer.popup_title
	)


## Mount an already-built content node (typically InjectableScene → popup scene).
func mount_content(node: Node) -> void:
	if node == null:
		return
	content_host.add_child(node)
	if node is Control:
		var control := node as Control
		control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.size_flags_vertical = Control.SIZE_EXPAND_FILL
		_content = control
	elif node.has_method("get_mounted_ui"):
		_content = node.get_mounted_ui()


## Legacy: apply describer visuals and instantiate content PackedScene directly.
func inject_popup_describer(describer: PopupDescriber):
	apply_describer(describer)
	_populate_scene(describer.content)


## Re-show an already built popup; the live content instance is kept.
func reset_popup(describer: PopupDescriber) -> void:
	scene_name = describer.popup_name
	_setup_visuals(
		describer.size,
		describer.position,
		describer.popup_title
	)
	visible = true


func get_content() -> Control:
	return _content


func _populate_scene(hosted_scene: PackedScene):
	var instance = hosted_scene.instantiate()
	_content = instance as Control
	content_host.add_child(instance)


func _setup_visuals(size: Vector2, position: Vector2, title: String):
	self.size = size
	self.position = position
	title_label.text = title
