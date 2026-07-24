extends Control

## Quest lock overlay. Main passes Dictionary: { quest_id, name, icon }

@onready var icon: TextureRect = $Panel/HBoxContainer/SkillIcon
@onready var quest_name: Label = $Panel/HBoxContainer/QuestName

var quest_id: String = ""


func set_requirement(data: Dictionary) -> void:
	quest_id = str(data.get("quest_id", ""))
	quest_name.text = str(data.get("name", ""))
	if data.get("icon") is Texture2D:
		icon.texture = data["icon"]
