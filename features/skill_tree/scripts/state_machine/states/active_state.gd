extends "res://ui/features/skill_tree/scripts/state_machine/node_state.gd"

@export var node_root: Node2D


func transition() -> void:
	var tween := create_tween()
	node_root.selected.visible = true
	node_root.animation_player.play("activation")
	var connection_link = node_root.active_connection
	var parent_ref = node_root.parent_node
	if not parent_ref:
		return
	var parent_position = parent_ref.global_position
	var target_pos: Vector2 = node_root.global_position - parent_position
	connection_link.position = parent_position - node_root.global_position
	var anim: PackedVector2Array = [Vector2(0, 0), target_pos]
	tween.tween_property(connection_link, "points", anim, 0.025).set_ease(Tween.EASE_OUT)
