extends TextureRect
class_name OffensiveTypeIcon

enum DamageStyle { ATTACK, STRENGTH }

const TYPE_MAP: Dictionary = {
	DamageStyle.ATTACK: preload("res://assets/skill_icons/attack.svg"),
	DamageStyle.STRENGTH: preload("res://assets/skill_icons/strength.svg"),
}


func set_type(offensive_type: DamageStyle) -> void:
	texture = TYPE_MAP.get(offensive_type, TYPE_MAP[DamageStyle.ATTACK])


func _on_style_selected(payload: int) -> void:
	set_type(payload as DamageStyle)
