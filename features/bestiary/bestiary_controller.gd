extends Node

@onready var enemy_bar: Panel = $"../VBoxContainer/BestiaryEnemyBar"
@onready var stats_panel: Panel = $"../VBoxContainer/BestiaryMain/StatsPanel"
@onready var art_panel: Panel = $"../VBoxContainer/BestiaryMain/ArtLoreColumn/BestiaryArt"
@onready var lore_panel: Panel = $"../VBoxContainer/BestiaryMain/ArtLoreColumn/BestiaryLore"
@onready var progress_footer: Panel = $"../VBoxContainer/BestiaryProgressFooter"

var _entries: Array[BestiaryEntry] = []
var _selected_id: String = ""
var _wired: bool = false


func _ready() -> void:
	_ensure_wired()
	## Standalone / preview: use sample catalog when Main has not injected entries yet.
	if _entries.is_empty():
		load_entries(BestiarySampleCatalog.build())


func load_entries(entries: Array[BestiaryEntry]) -> void:
	_ensure_wired()
	_entries = entries
	if _entries.is_empty():
		_selected_id = ""
		_refresh_bar()
		return

	var keep_selection := false
	for entry in _entries:
		if entry.id == _selected_id:
			keep_selection = true
			break
	if not keep_selection:
		_selected_id = _entries[0].id
		for entry in _entries:
			if entry.is_discovered():
				_selected_id = entry.id
				break

	_refresh_bar()
	_bind_selected()


func _ensure_wired() -> void:
	if _wired:
		return
	if enemy_bar and enemy_bar.has_signal("enemy_selected"):
		if not enemy_bar.enemy_selected.is_connected(_on_enemy_selected):
			enemy_bar.enemy_selected.connect(_on_enemy_selected)
	_wired = true


func _refresh_bar() -> void:
	var discovered := 0
	for entry in _entries:
		if entry.is_discovered():
			discovered += 1
	if enemy_bar and enemy_bar.has_method("set_header"):
		enemy_bar.call("set_header", discovered, _entries.size())
	if enemy_bar and enemy_bar.has_method("populate"):
		enemy_bar.call("populate", _entries, _selected_id)


func _bind_selected() -> void:
	var entry := _find_entry(_selected_id)
	if entry == null:
		return
	if stats_panel and stats_panel.has_method("bind_entry"):
		stats_panel.call("bind_entry", entry)
	if art_panel and art_panel.has_method("bind_entry"):
		art_panel.call("bind_entry", entry)
	if lore_panel and lore_panel.has_method("bind_entry"):
		lore_panel.call("bind_entry", entry)
	if progress_footer and progress_footer.has_method("bind_entry"):
		progress_footer.call("bind_entry", entry)
	if enemy_bar and enemy_bar.has_method("set_selected"):
		enemy_bar.call("set_selected", _selected_id)


func _on_enemy_selected(entry_id: String) -> void:
	if entry_id == _selected_id:
		return
	_selected_id = entry_id
	_bind_selected()


func _find_entry(entry_id: String) -> BestiaryEntry:
	for entry in _entries:
		if entry.id == entry_id:
			return entry
	return null
