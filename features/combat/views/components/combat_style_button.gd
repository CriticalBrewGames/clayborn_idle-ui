extends Button

enum WeaponType { ATTACK, STR, DEFENCE, AGILITY }

const MARGIN = 10

const COMBAT_MAPPING = {
	WeaponType.ATTACK: [preload("res://assets/skill_icons/attack.svg"), "Attack"],
	WeaponType.STR: [preload("res://assets/skill_icons/strength.svg"), "Strength"],
	WeaponType.DEFENCE: [preload("res://assets/skill_icons/defence.svg"), "Defence"],
	WeaponType.AGILITY: [preload("res://assets/skill_icons/agility.svg"), "Agility"]
}

@export var attack_type: WeaponType
@export var payload: int

@onready var combat_icon: TextureRect = $HBoxContainer/TextureRect
@onready var combat_name: Label = $HBoxContainer/Label

func _ready():
	_set_icon_content(attack_type)
	#_update_content()
	_update_size()


func _set_icon_content(to_get: WeaponType):
	var content: Array = COMBAT_MAPPING.get(to_get, [])
	if not content:
		return
	
	combat_icon.texture = content[0]
	combat_name.text = tr(content[1])


func _update_size():
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)

	var content_node = get_node_or_null("HBoxContainer")
	if not content_node:
		return

	var combined_size = content_node.get_combined_minimum_size()
	
	set_custom_minimum_size(Vector2(combined_size.x + MARGIN, combined_size.y + MARGIN))
