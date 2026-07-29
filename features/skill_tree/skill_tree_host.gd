extends Node2D

## Host root for a skill tree view. Main wires Core skill-point logic to signals
## from the child BinarySkillTree (`skill_tree.gd`).

signal node_activated(node: Node2D)
signal node_deactivated(node: Node2D)
signal invalid_node_activation()
signal available_skill_points_changed(free_points: int)

@export var tree_name: String = ""
@export var skill_tree_path: NodePath = NodePath("SkillTree")
@export var skill_points_label_path: NodePath = NodePath("SkillPointsLabel")

var _skill_tree: Node2D
var _points_label: Label
var _max_points: int = 0
var _used_points: int = 0


func _ready() -> void:
	_skill_tree = get_node_or_null(skill_tree_path)
	_points_label = get_node_or_null(skill_points_label_path)
	if _skill_tree:
		if tree_name and _skill_tree.has_method("set_tree_name"):
			_skill_tree.set_tree_name(tree_name)
		_wire_tree_signals()
	_refresh_points_label()


func _wire_tree_signals() -> void:
	if _skill_tree.has_signal("node_activated"):
		_skill_tree.node_activated.connect(_on_node_activated)
	if _skill_tree.has_signal("node_deactivated"):
		_skill_tree.node_deactivated.connect(_on_node_deactivated)
	if _skill_tree.has_signal("invalid_node_activation"):
		_skill_tree.invalid_node_activation.connect(func(): invalid_node_activation.emit())


## Main/Core calls this when skill points change.
func set_skill_points(max_points: int, used_points: int) -> void:
	_max_points = max_points
	_used_points = used_points
	_refresh_points_label()
	available_skill_points_changed.emit(maxi(0, _max_points - _used_points))


func get_free_skill_points() -> int:
	return maxi(0, _max_points - _used_points)


func serialize_skill_tree() -> Array:
	if _skill_tree and _skill_tree.has_method("serialize_nodes"):
		return _skill_tree.serialize_nodes()
	return []


func deserialize_skill_tree(data: Array) -> void:
	if _skill_tree and _skill_tree.has_method("deserialize_nodes"):
		_skill_tree.deserialize_nodes(data)


## Confirm activation after Core spends a point (Main calls this on success).
func confirm_activate(node: Node2D) -> void:
	if _skill_tree and _skill_tree.has_method("activate_target_node"):
		_skill_tree.activate_target_node(node)


func confirm_deactivate(node: Node2D) -> void:
	if _skill_tree and _skill_tree.has_method("deactivate_target_node"):
		_skill_tree.deactivate_target_node(node)


func _on_node_activated(node: Node2D) -> void:
	node_activated.emit(node)


func _on_node_deactivated(node: Node2D) -> void:
	node_deactivated.emit(node)


func _refresh_points_label() -> void:
	if _points_label:
		_points_label.text = tr("SKILL_TREE_POINTS") % get_free_skill_points()
