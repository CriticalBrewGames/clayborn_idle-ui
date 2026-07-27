extends Button

enum WeaponType { ATTACK, STR, DEFENCE, AGILITY }

const COMBAT_MAPPING = {
	WeaponType.ATTACK: preload("res://assets/skill_icons/attack.svg"),
	WeaponType.STR: preload("res://assets/skill_icons/strength.svg"),
	WeaponType.DEFENCE: preload("res://assets/skill_icons/defence.svg"),
	WeaponType.AGILITY: preload("res://assets/skill_icons/agility.svg"),
}

@export var attack_type: WeaponType
## Payload matches Core DamageType / DefenseType enum ints.
@export var payload: int

@onready var combat_icon: TextureRect = $TextureRect


func _ready() -> void:
	_set_icon_content(attack_type)


func _set_icon_content(to_get: WeaponType) -> void:
	var texture: Texture2D = COMBAT_MAPPING.get(to_get)
	if texture == null or combat_icon == null:
		return
	combat_icon.texture = texture
