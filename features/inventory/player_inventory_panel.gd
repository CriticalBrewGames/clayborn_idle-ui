extends Control

## Player inventory chrome: bag host, equipment host, stats, effect icons, HP bar.
## Main attaches Wyvernbox InventoryView into the host Controls and drives stats/effects
## via Dictionary APIs — no Core types in this script.

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
	stat_panel.looked_at.connect(_on_stats_looked_at)


## Nested Dictionary — see StatPanel.set_stats
func set_stats(stats: Dictionary) -> void:
	stat_panel.set_stats(stats)


func set_hp(current: int, maximum: int = -1) -> void:
	if maximum >= 0:
		hp_bar.change_max_hp(maximum)
	hp_bar.current_hp = current


func add_effect_icon(token: Variant, data: Dictionary) -> void:
	effect_icons_host.add_effect(token, data)


func update_effect_icon(token: Variant, data: Dictionary) -> void:
	effect_icons_host.update_effect(token, data)


func remove_effect_icon(token: Variant) -> void:
	effect_icons_host.remove_effect(token)


func clear_effect_icons() -> void:
	effect_icons_host.clear_effects()


## Mount a Wyvernbox InventoryView (or any Control) into the bag host.
func mount_bag_inventory(view: Control) -> void:
	_mount_into(bag_host, view)


## Mount a Wyvernbox InventoryView into the equipment host (replaces chrome Cells visibility optionally).
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
	# Hide placeholder labels if present
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
	stat_panel.set_open(open)
	stat_panel_toggled.emit(open)


func _on_stats_looked_at(toggled: bool, data: Dictionary) -> void:
	stats_looked_at.emit(toggled, data)
