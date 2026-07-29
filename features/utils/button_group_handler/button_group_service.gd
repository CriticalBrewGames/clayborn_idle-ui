extends RefCounted
class_name ButtonGroupRegistry

static var button_groups: Dictionary[StringName, ButtonGroup] = {}


static func get_group(group_name: StringName) -> ButtonGroup:
	if !button_groups.has(group_name):
		button_groups[group_name] = ButtonGroup.new()

	return button_groups[group_name]


static func remove_group(group_name: StringName) -> void:
	button_groups.erase(group_name)
