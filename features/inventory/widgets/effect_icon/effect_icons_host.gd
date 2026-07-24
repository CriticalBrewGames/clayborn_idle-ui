extends Control

## Host for active-effect icons. Main calls add/update/remove with Dictionary data.

const EFFECT_ICON_SCENE := preload("res://ui/features/inventory/widgets/effect_icon/effect_icon.tscn")

@onready var icon_container: HBoxContainer = $ScrollContainer/HBoxContainer

var _icon_map: Dictionary = {}


func add_effect(token: Variant, data: Dictionary) -> void:
	if _icon_map.has(token):
		update_effect(token, data)
		return
	var icon: Control = EFFECT_ICON_SCENE.instantiate()
	icon_container.add_child(icon)
	icon.bind_display(data, token)
	_icon_map[token] = icon


func update_effect(token: Variant, data: Dictionary) -> void:
	if not _icon_map.has(token):
		add_effect(token, data)
		return
	_icon_map[token].update_display(data)


func remove_effect(token: Variant) -> void:
	if not _icon_map.has(token):
		return
	var icon: Node = _icon_map[token]
	_icon_map.erase(token)
	icon.queue_free()


func clear_effects() -> void:
	for token in _icon_map.keys():
		_icon_map[token].queue_free()
	_icon_map.clear()
