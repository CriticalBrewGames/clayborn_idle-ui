#outdated
## UI character select incorrectly extends Main SceneBase; needs a Main InjectableScene wrapper + route.
extends SceneBase

signal character_selected(entry: CharacterEntry)


const CHARACTER_ROW_SCENE := preload("res://ui/features/main_menu/widgets/character_row.tscn")

@onready var list_host: VBoxContainer = $Center/Column/Panel/ListPanel/Margin/Scroll/ListHost
@onready var select_button: Button = $Center/Column/Actions/SelectButton
@onready var new_button: Button = $Center/Column/Actions/NewButton
@onready var creation_popup: Control = $CharacterCreationPopup
@onready var empty_label: Label = $Center/Column/Panel/ListPanel/Margin/Scroll/ListHost/EmptyLabel

@export var seed_characters: Array[CharacterEntry] = []

var _characters: Array[CharacterEntry] = []
var _selected_id: StringName = &""
var _row_by_id: Dictionary = {} # StringName -> Panel


func _ready() -> void:
	select_button.pressed.connect(_on_select_pressed)
	new_button.pressed.connect(_on_new_pressed)
	creation_popup.character_created.connect(_on_character_created)

	if seed_characters.is_empty():
		_characters = _default_seed()
	else:
		_characters = seed_characters.duplicate()

	_rebuild_list()
	_refresh_select_enabled()


func get_characters() -> Array[CharacterEntry]:
	return _characters


func get_selected() -> CharacterEntry:
	for entry in _characters:
		if entry.id == _selected_id:
			return entry
	return null


func add_character(entry: CharacterEntry) -> void:
	_characters.append(entry)
	_rebuild_list()
	_select(entry.id)


func _default_seed() -> Array[CharacterEntry]:
	var a := CharacterEntry.new()
	a.id = &"c1"
	a.character_name = "Zoltan"
	a.mode = CharacterEntry.GameMode.SOFTCORE

	var b := CharacterEntry.new()
	b.id = &"c2"
	b.character_name = "Mira"
	b.mode = CharacterEntry.GameMode.HARDCORE

	return [a, b]


func _rebuild_list() -> void:
	for child in list_host.get_children():
		if child == empty_label:
			continue
		list_host.remove_child(child)
		child.free()
	_row_by_id.clear()

	empty_label.visible = _characters.is_empty()

	for entry in _characters:
		var row := CHARACTER_ROW_SCENE.instantiate()
		list_host.add_child(row)
		row.setup(entry)
		row.row_selected.connect(_on_row_selected)
		_row_by_id[entry.id] = row
		row.set_selected(entry.id == _selected_id)

	if _selected_id == &"" and not _characters.is_empty():
		_select(_characters[0].id)
	elif _selected_id != &"" and not _row_by_id.has(_selected_id):
		_selected_id = &""
		if not _characters.is_empty():
			_select(_characters[0].id)
		else:
			_refresh_select_enabled()


func _select(id: StringName) -> void:
	_selected_id = id
	for row_id in _row_by_id:
		var row = _row_by_id[row_id]
		row.set_selected(row_id == _selected_id)
	_refresh_select_enabled()


func _refresh_select_enabled() -> void:
	select_button.disabled = _selected_id == &"" or get_selected() == null


func _on_row_selected(entry: CharacterEntry) -> void:
	if entry == null:
		return
	_select(entry.id)


func _on_select_pressed() -> void:
	var entry := get_selected()
	if entry == null:
		return
	new_page_request.emit(&"select_character", entry.character_name)


func _on_new_pressed() -> void:
	creation_popup.open_popup()


func _on_character_created(entry: CharacterEntry) -> void:
	add_character(entry)
