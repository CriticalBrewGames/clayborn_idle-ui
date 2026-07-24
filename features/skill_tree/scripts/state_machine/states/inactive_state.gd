extends "res://ui/features/skill_tree/scripts/state_machine/node_state.gd"

@export var node_root: Node2D


func transition() -> void:
	var tween := create_tween()
	node_root.selected.visible = false
	var connection_link = node_root.active_connection
	var anim: PackedVector2Array = [Vector2(0, 0), Vector2(0, 0)]
	tween.tween_property(connection_link, "points", anim, 0.025).set_ease(Tween.EASE_OUT)
