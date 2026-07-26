extends Control

## Player equipment panel for SM/MD breakpoints. At MD, stats are shown inline below gear.
## Main mounts Wyvernbox InventoryView into the equipment host.

signal stats_looked_at(toggled: bool, data: Dictionary)

@onready var _equipment_host: Control = $Panel/VBox/EquipmentHost
@onready var _stats_host: Control = $Panel/VBox/StatsHost
@onready var _stat_panel: Control = $Panel/VBox/StatsHost/StatPanel
@onready var _hp_bar: Control = $Panel/VBox/HpRow/PlayerHp


func _ready() -> void:
	if _stat_panel and _stat_panel.has_signal("looked_at"):
		if not _stat_panel.looked_at.is_connected(_on_stats_looked_at):
			_stat_panel.looked_at.connect(_on_stats_looked_at)


func set_stats_inline(visible: bool) -> void:
	if _stats_host:
		_stats_host.visible = visible


func set_stats(stats: Dictionary) -> void:
	if _stat_panel and _stat_panel.has_method("set_stats"):
		_stat_panel.set_stats(stats)


func set_hp(current: int, maximum: int = -1) -> void:
	if not _hp_bar:
		return
	if maximum >= 0 and _hp_bar.has_method("change_max_hp"):
		_hp_bar.change_max_hp(maximum)
	if "current_hp" in _hp_bar:
		_hp_bar.current_hp = current
	elif _hp_bar.has_method("set_current_hp"):
		_hp_bar.set_current_hp(current)


func mount_equipment_inventory(view: Control) -> void:
	_mount_into(_equipment_host, view)


func get_equipment_host() -> Control:
	return _equipment_host


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


func _on_stats_looked_at(toggled: bool, data: Dictionary) -> void:
	stats_looked_at.emit(toggled, data)
