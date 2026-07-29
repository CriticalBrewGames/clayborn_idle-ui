extends Node
class_name ButtonGroupBinder

@export var group_name: StringName
@export var button_container: Control

var _buttons: Array[BaseButton] = []


func _ready() -> void:
	var group := ButtonGroupRegistry.get_group(group_name)
	
	var all_buttons = button_container.find_children("*", "BaseButton", true, false)

	for buttons in all_buttons:
		var button := buttons as BaseButton
		button.button_group = group
		button.toggle_mode = true
		_buttons.append(button)


func _exit_tree() -> void:
	_cleanup()


func _cleanup() -> void:
	var group := ButtonGroupRegistry.get_group(group_name)

	for button in group.get_buttons():
		if button not in _buttons:
			return

	ButtonGroupRegistry.remove_group(group_name)
