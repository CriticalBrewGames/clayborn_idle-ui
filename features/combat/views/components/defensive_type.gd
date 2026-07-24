extends TextureRect
class_name DefensiveTypeIcon

enum DefenseStyle { DEFENCE, AGILITY }

const TYPE_MAP: Dictionary = {
	DefenseStyle.DEFENCE: preload("res://assets/skill_icons/defence.svg"),
	DefenseStyle.AGILITY: preload("res://assets/skill_icons/agility.svg"),
}


func set_type(defensive_type: DefenseStyle) -> void:
	texture = TYPE_MAP.get(defensive_type, TYPE_MAP[DefenseStyle.DEFENCE])


func _on_style_selected(payload: int) -> void:
	set_type(payload as DefenseStyle)
