extends TextureRect
class_name OffensiveTypeIcon

enum DamageStyle { ATTACK, STRENGTH }

const TYPE_MAP: Dictionary = {
	DamageStyle.ATTACK: preload("res://assets/skill_icons/attack.svg"),
	DamageStyle.STRENGTH: preload("res://assets/skill_icons/strength.svg"),
}


func set_type(offensive_type: DamageStyle) -> void:
	texture = TYPE_MAP.get(offensive_type, TYPE_MAP[DamageStyle.ATTACK])


func set_type_from_int(style: int) -> void:
	## Maps Core OffensiveComponent styles onto the two icons this widget supports.
	if style == int(DamageStyle.STRENGTH):
		set_type(DamageStyle.STRENGTH)
	else:
		set_type(DamageStyle.ATTACK)


func _on_style_selected(payload: int) -> void:
	set_type(payload as DamageStyle)
