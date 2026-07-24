extends "res://ui/features/skill_tree/scripts/state_machine/node_state.gd"

@export var node_graph: Sprite2D

var root_texture = preload("res://assets/node_system/node_root.png")


func transition() -> void:
	if not node_graph:
		var parent_node = get_parent().get_parent()
		if parent_node and parent_node.has_node("NodeGraph"):
			node_graph = parent_node.get_node("NodeGraph")
	if node_graph:
		node_graph.texture = root_texture
	else:
		push_error("RootState: node_graph is null! Cannot update texture.")
