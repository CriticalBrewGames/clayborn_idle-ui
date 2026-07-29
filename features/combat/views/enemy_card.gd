extends Panel

## Dumb monster picker card. Main supplies plain display data; UI emits id only.

signal selected(monster_id: String)

@onready var name_label: Label = $Margin/VBox/Name
@onready var level_label: Label = $Margin/VBox/Level
@onready var sprite: TextureRect = $Margin/VBox/Sprite
@onready var fight_button: Button = $Margin/VBox/FightButton
@onready var lock_overlay: ColorRect = $LockOverlay

var monster_id: String = ""
var display_name: String = ""
var level: int = 0
var locked: bool = false


func _ready() -> void:
	if fight_button and not fight_button.pressed.is_connected(_on_fight_pressed):
		fight_button.pressed.connect(_on_fight_pressed)
	_apply()


func setup(data: Dictionary) -> void:
	monster_id = str(data.get("id", ""))
	display_name = str(data.get("name", monster_id))
	level = int(data.get("level", 0))
	locked = bool(data.get("locked", false))
	if data.get("sprite") is Texture2D:
		if sprite == null:
			sprite = get_node_or_null("Margin/VBox/Sprite") as TextureRect
		if sprite:
			sprite.texture = data["sprite"]
	_apply()


func set_locked(is_locked: bool) -> void:
	locked = is_locked
	_apply()


func _apply() -> void:
	if name_label:
		name_label.text = display_name
	if level_label:
		level_label.text = tr("COMBAT_LEVEL") % level
	if fight_button:
		fight_button.disabled = locked or monster_id.is_empty()
	if lock_overlay:
		lock_overlay.visible = locked


func _on_fight_pressed() -> void:
	if locked or monster_id.is_empty():
		return
	selected.emit(monster_id)
