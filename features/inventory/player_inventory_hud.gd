extends Control

## Responsive player inventory HUD.
## SM/MD: bottom-left quick buttons emit payloads for Main to route.
## LG+: archive-style desktop panel anchored bottom-right.

signal payload_pressed(payload: String)
signal heal_requested(amount: int)
signal apply_effect_requested(effect_id: String)
signal stats_looked_at(toggled: bool, data: Dictionary)
signal stat_panel_toggled(open: bool)

@onready var _quick_buttons: Control = $QuickAccessButtons
@onready var _desktop_panel: Control = $DesktopPanel


func _ready() -> void:
	if _quick_buttons and _quick_buttons.has_signal("payload_pressed"):
		if not _quick_buttons.payload_pressed.is_connected(_forward_payload):
			_quick_buttons.payload_pressed.connect(_forward_payload)
	_connect_desktop_signals()


func set_stats(stats: Dictionary) -> void:
	if _desktop_panel and _desktop_panel.has_method("set_stats"):
		_desktop_panel.set_stats(stats)


func set_hp(current: int, maximum: int = -1) -> void:
	if _desktop_panel and _desktop_panel.has_method("set_hp"):
		_desktop_panel.set_hp(current, maximum)


func add_effect_icon(token: Variant, data: Dictionary) -> void:
	if _desktop_panel and _desktop_panel.has_method("add_effect_icon"):
		_desktop_panel.add_effect_icon(token, data)


func update_effect_icon(token: Variant, data: Dictionary) -> void:
	if _desktop_panel and _desktop_panel.has_method("update_effect_icon"):
		_desktop_panel.update_effect_icon(token, data)


func remove_effect_icon(token: Variant) -> void:
	if _desktop_panel and _desktop_panel.has_method("remove_effect_icon"):
		_desktop_panel.remove_effect_icon(token)


func clear_effect_icons() -> void:
	if _desktop_panel and _desktop_panel.has_method("clear_effect_icons"):
		_desktop_panel.clear_effect_icons()


func mount_bag_inventory(view: Control) -> void:
	if _desktop_panel and _desktop_panel.has_method("mount_bag_inventory"):
		_desktop_panel.mount_bag_inventory(view)


func mount_equipment_inventory(view: Control) -> void:
	if _desktop_panel and _desktop_panel.has_method("mount_equipment_inventory"):
		_desktop_panel.mount_equipment_inventory(view)


func get_bag_host() -> Control:
	if _desktop_panel and _desktop_panel.has_method("get_bag_host"):
		return _desktop_panel.get_bag_host()
	return null


func get_equipment_host() -> Control:
	if _desktop_panel and _desktop_panel.has_method("get_equipment_host"):
		return _desktop_panel.get_equipment_host()
	return null


func get_quick_buttons() -> Control:
	return _quick_buttons


func get_desktop_panel() -> Control:
	return _desktop_panel


func _connect_desktop_signals() -> void:
	if not _desktop_panel:
		return
	if _desktop_panel.has_signal("heal_requested"):
		_desktop_panel.heal_requested.connect(func(amount): heal_requested.emit(amount))
	if _desktop_panel.has_signal("apply_effect_requested"):
		_desktop_panel.apply_effect_requested.connect(func(effect_id): apply_effect_requested.emit(effect_id))
	if _desktop_panel.has_signal("stats_looked_at"):
		_desktop_panel.stats_looked_at.connect(func(toggled, data): stats_looked_at.emit(toggled, data))
	if _desktop_panel.has_signal("stat_panel_toggled"):
		_desktop_panel.stat_panel_toggled.connect(func(open): stat_panel_toggled.emit(open))


func _forward_payload(payload: String) -> void:
	payload_pressed.emit(payload)
