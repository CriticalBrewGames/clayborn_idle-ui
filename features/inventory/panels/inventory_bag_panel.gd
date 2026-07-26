extends Control

## Player bag panel for SM/MD breakpoints. Main mounts Wyvernbox InventoryView into the host.

signal heal_requested(amount: int)

@onready var _bag_host: Control = $Panel/BagHost
@onready var _effect_icons_host: Control = $EffectIconsHost


func mount_bag_inventory(view: Control) -> void:
	_mount_into(_bag_host, view)


func get_bag_host() -> Control:
	return _bag_host


func add_effect_icon(token: Variant, data: Dictionary) -> void:
	if _effect_icons_host and _effect_icons_host.has_method("add_effect"):
		_effect_icons_host.add_effect(token, data)


func update_effect_icon(token: Variant, data: Dictionary) -> void:
	if _effect_icons_host and _effect_icons_host.has_method("update_effect"):
		_effect_icons_host.update_effect(token, data)


func remove_effect_icon(token: Variant) -> void:
	if _effect_icons_host and _effect_icons_host.has_method("remove_effect"):
		_effect_icons_host.remove_effect(token)


func clear_effect_icons() -> void:
	if _effect_icons_host and _effect_icons_host.has_method("clear_effects"):
		_effect_icons_host.clear_effects()


func _mount_into(host: Control, view: Control) -> void:
	if not host or not view:
		return
	for child in host.get_children():
		if child is Label and child.name == "Placeholder":
			child.visible = false
	if view.get_parent() != host:
		if view.get_parent():
			view.get_parent().remove_child(view)
		host.add_child(view)
	view.set_anchors_preset(Control.PRESET_FULL_RECT)
	view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	view.size_flags_vertical = Control.SIZE_EXPAND_FILL
