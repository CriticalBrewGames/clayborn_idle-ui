extends Node2D

## Presentation-only binary skill tree. Emits activation signals for Main/Core
## to validate skill points. No BinaryTreeSkillSystem / Core type references.

signal node_activated(node: Node2D)
signal node_deactivated(node: Node2D)
signal invalid_node_activation()
signal node_enabled(node: Node2D)

const SkillNodeScript = preload("res://ui/features/skill_tree/scripts/skill_node.gd")

@export var root_node: Node2D
var skill_tree_name: String = ""
var _flat_skill_tree: Array = []


func _ready() -> void:
	if root_node:
		connect_nodes(root_node)


func connect_nodes(node) -> void:
	node.set_node_name(skill_tree_name)
	if node not in _flat_skill_tree:
		_flat_skill_tree.append(node)

	if node.left_child:
		node.setup_child_data(node.left_child)
		connect_nodes(node.left_child)
		node.left_child.connect("emit_click", _check_if_node_valid.bind(node.left_child))

	if node.right_child:
		node.setup_child_data(node.right_child)
		connect_nodes(node.right_child)
		node.right_child.connect("emit_click", _check_if_node_valid.bind(node.right_child))


func serialize_nodes() -> Array:
	var result: Array = []
	for node in _flat_skill_tree:
		if node.node_state != SkillNodeScript.State.INACTIVE:
			result.append(node.node_name)
	return result


func deserialize_nodes(data: Array) -> void:
	for node in _flat_skill_tree:
		if data.find(node.node_name) == -1:
			continue
		if node != root_node:
			node.set_state(SkillNodeScript.State.ACTIVE)
			node_enabled.emit(node)


func set_tree_name(new_skill_tree_name: String) -> void:
	skill_tree_name = new_skill_tree_name


func activate_target_node(node) -> void:
	var target = _travers_for_target(node, root_node)
	if target:
		target.set_state(SkillNodeScript.State.ACTIVE)


func deactivate_target_node(node) -> void:
	var target = _travers_for_target(node, root_node)
	if target:
		target.set_state(SkillNodeScript.State.INACTIVE)


func _travers_for_target(target, current_node, check_state: bool = false):
	if current_node == target:
		return current_node
	if check_state and current_node.node_state == SkillNodeScript.State.INACTIVE:
		return null
	if current_node.left_child:
		var result = _travers_for_target(target, current_node.left_child, check_state)
		if result:
			return result
	if current_node.right_child:
		var result = _travers_for_target(target, current_node.right_child, check_state)
		if result:
			return result
	return null


func _disalbe_all_child(node, total_n: int = 0) -> int:
	node.set_state(SkillNodeScript.State.INACTIVE)
	total_n += 1
	node_deactivated.emit(node)
	if node.left_child and node.left_child.node_state == SkillNodeScript.State.ACTIVE:
		total_n = _disalbe_all_child(node.left_child, total_n)
	if node.right_child and node.right_child.node_state == SkillNodeScript.State.ACTIVE:
		total_n = _disalbe_all_child(node.right_child, total_n)
	return total_n


func _check_if_node_valid(node) -> void:
	if node.node_state == SkillNodeScript.State.INACTIVE:
		var target_node = _travers_for_target(node, root_node, true)
		if target_node:
			node_activated.emit(node)
		else:
			invalid_node_activation.emit()
	elif node.node_state == SkillNodeScript.State.ACTIVE:
		_disalbe_all_child(node)
