class_name SkillButton extends PayloadButton


@onready var icon_node: TextureRect = $TextureButton
@onready var level_label: Label = $Label


var skill_name: String = ""
var skill_level: int = 0
var skill_xp: float = 0.0

## Alias used by skill data binding; kept in sync with payload.
var skill_id: String:
	get:
		return payload
	set(value):
		payload = value


func _ready() -> void:
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


## data keys: skill_id, name, level, xp, icon (Texture2D)
func update_from_data(data: Dictionary) -> void:
	if data.has("skill_id"):
		payload = StringName(str(data["skill_id"]))
	if data.has("name"):
		set_skill_name(str(data["name"]))
	if data.has("level"):
		set_player_level(int(data["level"]))
	if data.has("xp"):
		set_xp(float(data["xp"]))
	if data.get("icon") is Texture2D:
		change_icon(data["icon"])


func set_skill_name(value: String) -> void:
	skill_name = value
	tooltip_text = skill_name


func set_xp(total_xp: float) -> void:
	skill_xp = total_xp


func set_player_level(level: int) -> void:
	skill_level = level
	if level_label:
		level_label.text = str(skill_level)


func change_icon(new_icon: Texture2D) -> void:
	if icon_node:
		icon_node.texture = new_icon
