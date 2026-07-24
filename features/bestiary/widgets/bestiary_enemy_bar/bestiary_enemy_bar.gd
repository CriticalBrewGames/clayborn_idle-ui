extends Panel

signal enemy_selected(entry_id: String)
signal search_changed(query: String)

@onready var title_label: Label = $Margin/VBox/HeaderRow/Title
@onready var discovered_label: Label = $Margin/VBox/HeaderRow/Discovered
@onready var search: LineEdit = $Margin/VBox/Search
@onready var thumb_row: HBoxContainer = $Margin/VBox/Scroll/ThumbRow

var _thumb_scene: PackedScene = preload("res://ui/features/bestiary/widgets/enemy_thumb/enemy_thumb.tscn")
var _thumbs: Dictionary = {}


func _ready() -> void:
	if search:
		search.text_changed.connect(_on_search_changed)


func set_header(discovered_count: int, total_count: int) -> void:
	if discovered_label:
		discovered_label.text = "%d / %d discovered" % [discovered_count, total_count]


func populate(entries: Array[BestiaryEntry], selected_id: String) -> void:
	for child in thumb_row.get_children():
		child.queue_free()
	_thumbs.clear()

	for entry in entries:
		var thumb: Panel = _thumb_scene.instantiate()
		thumb_row.add_child(thumb)
		if thumb.has_method("setup"):
			thumb.call("setup", entry, entry.id == selected_id)
		if thumb.has_signal("selected"):
			thumb.selected.connect(_on_thumb_selected)
		_thumbs[entry.id] = thumb


func set_selected(entry_id: String) -> void:
	for id in _thumbs.keys():
		var thumb: Node = _thumbs[id]
		if thumb and thumb.has_method("set_selected"):
			thumb.call("set_selected", id == entry_id)


func filter_visible(query: String) -> void:
	var q := query.strip_edges().to_lower()
	for id in _thumbs.keys():
		var thumb: Control = _thumbs[id]
		if thumb == null:
			continue
		if q.is_empty():
			thumb.visible = true
			continue
		var name_text := ""
		if "display_name" in thumb:
			name_text = String(thumb.display_name)
		var discovered := true
		if "discovered" in thumb:
			discovered = bool(thumb.discovered)
		var haystack := name_text.to_lower() if discovered else "unknown"
		thumb.visible = haystack.contains(q) or String(id).to_lower().contains(q)


func _on_thumb_selected(entry_id: String) -> void:
	enemy_selected.emit(entry_id)


func _on_search_changed(new_text: String) -> void:
	filter_visible(new_text)
	search_changed.emit(new_text)
