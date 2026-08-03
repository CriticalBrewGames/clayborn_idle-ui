extends Control

## Player inventory chrome: bag host, equipment host, stats, effect icons, HP bar.
## Main attaches Wyvernbox InventoryView into the WyvenboxTemplate hosts and drives
## stats/effects via Dictionary APIs — no Core types in this script.

signal heal_requested(amount: int)
signal apply_effect_requested(effect_id: String)
signal stats_looked_at(toggled: bool, data: Dictionary)
signal stat_panel_toggled(open: bool)

@onready var bag_host: Control = $Panel/VBoxContainer/BagWrap/WyvenboxTemplate
@onready var equipment_host: Control = $Panel/VBoxContainer/EquipmentHost
@onready var effect_icons_host: Control = $EffectIconsHost
@onready var stat_panel: Control = $StatMenu/Control/StatPanel
@onready var stat_toggle: Button = $Panel/StatToggle
@onready var hp_bar: Control = $Panel/VBoxContainer/PlayerHp


func _ready() -> void:
	if stat_toggle and stat_toggle.has_signal("stat_button_pressed"):
		if not stat_toggle.stat_button_pressed.is_connected(_on_stat_toggle):
			stat_toggle.stat_button_pressed.connect(_on_stat_toggle)
	if stat_panel and stat_panel.has_signal("looked_at"):
		if not stat_panel.looked_at.is_connected(_on_stats_looked_at):
			stat_panel.looked_at.connect(_on_stats_looked_at)


## Nested Dictionary — see StatPanel.set_stats
func set_stats(stats: Dictionary) -> void:
	if stat_panel and stat_panel.has_method("set_stats"):
		stat_panel.set_stats(stats)


func set_hp(current: int, maximum: int = -1) -> void:
	if not hp_bar:
		return
	if maximum >= 0 and hp_bar.has_method("change_max_hp"):
		hp_bar.change_max_hp(maximum)
	if "current_hp" in hp_bar:
		hp_bar.current_hp = current
	elif hp_bar.has_method("set_current_hp"):
		hp_bar.set_current_hp(current)


func add_effect_icon(token: Variant, data: Dictionary) -> void:
	if effect_icons_host and effect_icons_host.has_method("add_effect"):
		effect_icons_host.add_effect(token, data)


func update_effect_icon(token: Variant, data: Dictionary) -> void:
	if effect_icons_host and effect_icons_host.has_method("update_effect"):
		effect_icons_host.update_effect(token, data)


func remove_effect_icon(token: Variant) -> void:
	if effect_icons_host and effect_icons_host.has_method("remove_effect"):
		effect_icons_host.remove_effect(token)


func clear_effect_icons() -> void:
	if effect_icons_host and effect_icons_host.has_method("clear_effects"):
		effect_icons_host.clear_effects()


## Mount a Wyvernbox InventoryView (or any Control) into the bag host.
func mount_bag_inventory(view: Control) -> void:
	_mount_into(bag_host, view)


## Mount a Wyvernbox InventoryView into the equipment host.
func mount_equipment_inventory(view: Control) -> void:
	_mount_into(equipment_host, view)


func get_bag_host() -> Control:
	return bag_host


func get_equipment_host() -> Control:
	return equipment_host


func get_effect_icons_host() -> Control:
	return effect_icons_host


func _mount_into(host: Control, view: Control) -> void:
	if not host or not view:
		return
	if host.has_method("inject_inventory_view") and view is InventoryView:
		host.inject_inventory_view(view)
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


func _on_stat_toggle(open: bool) -> void:
	if stat_panel and stat_panel.has_method("_open_stat_menu"):
		stat_panel._open_stat_menu(open)
	stat_panel_toggled.emit(open)


func _on_stats_looked_at(toggled: bool, data: Dictionary) -> void:
	stats_looked_at.emit(toggled, data)
