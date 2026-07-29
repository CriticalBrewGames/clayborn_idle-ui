extends PayloadButton

enum AttackType { ATTACK, STR, DEFENCE, AGILITY }

const COMBAT_MAPPING = {
	AttackType.ATTACK: preload("res://assets/skill_icons/attack.svg"),
	AttackType.STR: preload("res://assets/skill_icons/strength.svg"),
	AttackType.DEFENCE: preload("res://assets/skill_icons/defence.svg"),
	AttackType.AGILITY: preload("res://assets/skill_icons/agility.svg"),
}

@onready var combat_icon: TextureRect = $TextureRect

@export var attack_type: AttackType

func _ready() -> void:
	_set_icon_content(attack_type)


func _set_icon_content(to_get: AttackType) -> void:
	var texture: Texture2D = COMBAT_MAPPING.get(to_get)
	if texture == null or combat_icon == null:
		return
	combat_icon.texture = texture
