extends Control

## Dumb enemy picker. Main calls populate() with Dictionary entries; UI emits monster ids.

signal enemy_selected(monster_id: String)

const CARD_SCENE := preload("res://ui/features/combat/views/enemy_card.tscn")

@onready var cards_container: HBoxContainer = $Panel/VBoxContainer/ScrollContainer/HBoxContainer
@onready var search_edit: LineEdit = $Panel/VBoxContainer/LineEdit

var _entries: Array = []
var _cards: Array = []


func _ready() -> void:
	if search_edit and not search_edit.text_changed.is_connected(_on_search_changed):
		search_edit.text_changed.connect(_on_search_changed)


## entries: Array of { id, name, level, sprite?, locked? }
func populate(entries: Array) -> void:
	_entries = entries.duplicate()
	_rebuild_cards()


func clear() -> void:
	_entries.clear()
	_clear_cards()


func _clear_cards() -> void:
	if cards_container == null:
		cards_container = get_node_or_null("Panel/VBoxContainer/ScrollContainer/HBoxContainer") as HBoxContainer
	if cards_container == null:
		return
	for child in cards_container.get_children():
		child.queue_free()
	_cards.clear()


func _rebuild_cards() -> void:
	_clear_cards()
	if cards_container == null:
		return
	var query := ""
	if search_edit:
		query = search_edit.text.strip_edges().to_lower()
	for entry in _entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var entry_name := str(entry.get("name", "")).to_lower()
		if not query.is_empty() and entry_name.find(query) < 0:
			continue
		var card = CARD_SCENE.instantiate()
		cards_container.add_child(card)
		if card.has_method("setup"):
			card.setup(entry)
		if card.has_signal("selected") and not card.selected.is_connected(_on_card_selected):
			card.selected.connect(_on_card_selected)
		_cards.append(card)


func _on_card_selected(monster_id: String) -> void:
	enemy_selected.emit(monster_id)


func _on_search_changed(_text: String) -> void:
	_rebuild_cards()
