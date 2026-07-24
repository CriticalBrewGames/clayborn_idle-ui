extends Node2D

## Visual skill-tree node. Attribute payload is duck-typed (Dictionary or object
## with name/description/sprite). Core BinaryTreeSkillSystem stays in Main/Core.

signal emit_click

enum State { ROOT, INACTIVE, ACTIVE }

@onready var state_machine = $StateMachine
@onready var highlight = $Highlight
@onready var line_connection = $Connections/Connection
@onready var active_connection = $Connections/ConnectionActive
@onready var selected = $Selected
@onready var animation_player = $NodeGraph/AnimationPlayer
@onready var attrib_sprite = $AttribSprite
@onready var tooltip = $ColorRect

@export var node_state: State:
	set(new_state):
		node_state = new_state
		if state_machine:
			state_machine.set_state(new_state)
	get:
		return node_state

## Duck-typed: Dictionary {name, description, sprite} or object with those fields.
@export var attribute: Variant
@export var id: int = 1

var left_child  # SkillNode
var right_child  # SkillNode
var node_name: String = ""
var parent_node = null  # SkillNode — avoid shadowing Node.parent
var is_node_active := false


func _ready() -> void:
	for child in get_children():
		if child.get_script() == get_script():
			if not left_child:
				left_child = child
			elif not right_child:
				right_child = child

	if node_state == State.ROOT and state_machine:
		state_machine.set_state(node_state)

	_apply_attribute_tooltip()


func _apply_attribute_tooltip() -> void:
	if not attribute or not tooltip:
		return
	var attr_name := ""
	var attr_desc := ""
	var sprite_path = null
	if attribute is Dictionary:
		attr_name = str(attribute.get("name", ""))
		attr_desc = str(attribute.get("description", ""))
		sprite_path = attribute.get("sprite", null)
	else:
		attr_name = str(attribute.name) if "name" in attribute else ""
		attr_desc = str(attribute.description) if "description" in attribute else ""
		sprite_path = attribute.sprite if "sprite" in attribute else null
	if tooltip.has_method("set_tooltip"):
		tooltip.set_tooltip(attr_name, attr_desc)
	if sprite_path and attrib_sprite:
		if sprite_path is Texture2D:
			attrib_sprite.texture = sprite_path
		elif typeof(sprite_path) == TYPE_STRING and sprite_path != "":
			attrib_sprite.texture = load(sprite_path)


func set_node_name(name_prefix: String) -> void:
	node_name = "%s_%d" % [name_prefix, id]


func setup_child_data(target_node) -> void:
	target_node.parent_node = self
	target_node.set_connection(global_position)


func set_connection(parent_node_position: Vector2) -> void:
	var target_pos: Vector2 = to_local(parent_node_position)
	line_connection.points = [Vector2(0, 0), target_pos]


func set_state(new_state: State) -> void:
	node_state = new_state


func get_state():
	return node_state


func _on_hover_area_mouse_entered() -> void:
	highlight.visible = true
	if node_state != State.ROOT:
		$ColorRect.visible = true


func _on_hover_area_mouse_exited() -> void:
	highlight.visible = false
	$ColorRect.visible = false


func _on_hover_area_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			emit_signal("emit_click")
