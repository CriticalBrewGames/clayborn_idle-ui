class_name UIUpdaterBase extends Node

static func update_min_max_size_x(node: Control, width: float) -> void:
	node.custom_minimum_size.x = width
	node.custom_maximum_size.x = width
	node.size.x = width


static func update_min_max_size_y(node: Control, height: float) -> void:
	node.custom_minimum_size.y = height
	node.custom_maximum_size.y = height
	node.size.y = height


static func update_min_max_size(node: Control, size: Vector2) -> void:
	update_min_max_size_x(node, size.x)
	update_min_max_size_y(node, size.y)


static func force_refresh_anchor(node: Control) -> void:
	var anchors := [
		node.anchor_left,
		node.anchor_top,
		node.anchor_right,
		node.anchor_bottom,
	]

	var offsets := [
		node.offset_left,
		node.offset_top,
		node.offset_right,
		node.offset_bottom,
	]

	node.set_anchors_preset(Control.PRESET_TOP_LEFT)

	node.anchor_left = anchors[0]
	node.anchor_top = anchors[1]
	node.anchor_right = anchors[2]
	node.anchor_bottom = anchors[3]

	node.offset_left = offsets[0]
	node.offset_top = offsets[1]
	node.offset_right = offsets[2]
	node.offset_bottom = offsets[3]


static func nullify_size(node: Control):
	node.size = Vector2(0,0)
