extends Node

## Maps SkillNode.State enums to visual state scripts.

const SkillNodeScript = preload("res://ui/features/skill_tree/scripts/skill_node.gd")

@onready var states: Dictionary = {
	SkillNodeScript.State.ROOT: $RootState,
	SkillNodeScript.State.INACTIVE: $InactiveState,
	SkillNodeScript.State.ACTIVE: $ActiveState,
}

var current_state_node = null
var current_state_id = -1


func set_state(new_state_id) -> void:
	if new_state_id == current_state_id:
		return
	current_state_id = new_state_id
	current_state_node = states[new_state_id]
	current_state_node.transition()
