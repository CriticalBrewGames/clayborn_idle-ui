extends Control

## Skill / quest lock overlay. Main drives display with Dictionary data — no Core types.
## Expected keys: icon (Texture2D), level (int), skill_id (String, optional)

@onready var icon: TextureRect = $Panel/SkillIcon
@onready var level_req: Label = $Panel/SkillLevel
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var skill_id: String = ""
var skill_level: int = 0


func set_requirement(data: Dictionary) -> void:
	skill_id = str(data.get("skill_id", ""))
	skill_level = int(data.get("level", 0))
	if data.get("icon") is Texture2D:
		icon.texture = data["icon"]
	level_req.text = str(skill_level)


func set_icon(texture: Texture2D) -> void:
	if icon:
		icon.texture = texture


func unlock() -> void:
	if anim_player:
		anim_player.play("unlocked")
