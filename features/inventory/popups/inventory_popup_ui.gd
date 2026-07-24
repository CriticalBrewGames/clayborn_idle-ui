extends Control

## Draggable popup shell for inventory / gear / stats panels on SM and MD breakpoints.
## Main shows this popup and calls show_inventory(), show_gear(), or show_stats().

signal close_pressed
signal stats_looked_at(toggled: bool, data: Dictionary)

enum ContentMode { NONE, INVENTORY, GEAR, STATS }

const _POPUP_SIZES: Dictionary = {
	ContentMode.INVENTORY: Vector2(360, 420),
	ContentMode.GEAR: Vector2(360, 560),
	ContentMode.STATS: Vector2(300, 520),
}

@onready var _title_label: Label = $TilePanel/Label
@onready var _close_button: Button = $TilePanel/Button
@onready var _content_host: Control = $ContentHost
@onready var _inventory_panel: Control = $ContentHost/InventoryBagPanel
@onready var _gear_panel: Control = $ContentHost/GearPanel
@onready var _stats_panel: Control = $ContentHost/StatsPopupPanel

var _mode: ContentMode = ContentMode.NONE


func _ready() -> void:
	custom_minimum_size = _POPUP_SIZES[ContentMode.INVENTORY]
	if _close_button:
		_close_button.pressed.connect(_on_close_pressed)
	if _gear_panel and _gear_panel.has_signal("stats_looked_at"):
		_gear_panel.stats_looked_at.connect(_forward_stats_looked_at)
	if _stats_panel and _stats_panel.has_signal("stats_looked_at"):
		_stats_panel.stats_looked_at.connect(_forward_stats_looked_at)
	show_content(ContentMode.NONE)


func show_inventory() -> void:
	show_content(ContentMode.INVENTORY)


func show_gear(include_stats: bool = false) -> void:
	if _gear_panel and _gear_panel.has_method("set_stats_inline"):
		_gear_panel.set_stats_inline(include_stats)
	show_content(ContentMode.GEAR)


func show_stats() -> void:
	show_content(ContentMode.STATS)


func show_content(mode: ContentMode) -> void:
	_mode = mode
	_inventory_panel.visible = mode == ContentMode.INVENTORY
	_gear_panel.visible = mode == ContentMode.GEAR
	_stats_panel.visible = mode == ContentMode.STATS
	if _POPUP_SIZES.has(mode):
		custom_minimum_size = _POPUP_SIZES[mode]
	match mode:
		ContentMode.INVENTORY:
			_title_label.text = "Inventory"
		ContentMode.GEAR:
			_title_label.text = "Equipment"
		ContentMode.STATS:
			_title_label.text = "Stats"
		_:
			_title_label.text = "Panel"


func set_stats(stats: Dictionary) -> void:
	if _gear_panel and _gear_panel.has_method("set_stats"):
		_gear_panel.set_stats(stats)
	if _stats_panel and _stats_panel.has_method("set_stats"):
		_stats_panel.set_stats(stats)


func set_hp(current: int, maximum: int = -1) -> void:
	if _gear_panel and _gear_panel.has_method("set_hp"):
		_gear_panel.set_hp(current, maximum)


func mount_bag_inventory(view: Control) -> void:
	if _inventory_panel and _inventory_panel.has_method("mount_bag_inventory"):
		_inventory_panel.mount_bag_inventory(view)


func mount_equipment_inventory(view: Control) -> void:
	if _gear_panel and _gear_panel.has_method("mount_equipment_inventory"):
		_gear_panel.mount_equipment_inventory(view)


func get_inventory_panel() -> Control:
	return _inventory_panel


func get_gear_panel() -> Control:
	return _gear_panel


func get_stats_panel() -> Control:
	return _stats_panel


func _on_close_pressed() -> void:
	visible = false
	close_pressed.emit()


func _forward_stats_looked_at(toggled: bool, data: Dictionary) -> void:
	stats_looked_at.emit(toggled, data)
