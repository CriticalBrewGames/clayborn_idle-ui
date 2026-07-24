extends Control

## Popup content for player stats on the SM breakpoint (separate from gear).

signal stats_looked_at(toggled: bool, data: Dictionary)

@onready var _stat_panel: Control = $StatPanel


func _ready() -> void:
	if _stat_panel and _stat_panel.has_signal("looked_at"):
		if not _stat_panel.looked_at.is_connected(_on_stats_looked_at):
			_stat_panel.looked_at.connect(_on_stats_looked_at)


func set_stats(stats: Dictionary) -> void:
	if _stat_panel and _stat_panel.has_method("set_stats"):
		_stat_panel.set_stats(stats)


func _on_stats_looked_at(toggled: bool, data: Dictionary) -> void:
	stats_looked_at.emit(toggled, data)
