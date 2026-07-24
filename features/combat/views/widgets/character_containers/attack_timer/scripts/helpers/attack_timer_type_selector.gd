@tool
class_name AttackTimerOwnerSelector extends Node

enum UiOwner {
	PLAYER,
	ENEMY
}

@export var progress_bar: ExtendedProgressBar
@export var combat_style_icon_container: Panel

@export var ui_owner: UiOwner:
	set(value):
		ui_owner = value
		if is_node_ready():
			_update_layout()

func _ready() -> void:
	_update_layout()

func _update_layout() -> void:
	if not progress_bar or not combat_style_icon_container:
		print("Cannot find references yet")
		return
		
	var root = get_parent()
	if not root:
		return

	match ui_owner:
		UiOwner.PLAYER:
			root.move_child(combat_style_icon_container, 0)
			root.move_child(progress_bar, 1)
		UiOwner.ENEMY:
			root.move_child(progress_bar, 0)
			root.move_child(combat_style_icon_container, 1)


func get_attack_timer_owner() -> UiOwner:
	return ui_owner
