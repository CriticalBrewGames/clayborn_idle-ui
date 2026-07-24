extends BoxContainer

@onready var owner_selector = $AttackTimerOwnerSelector

@export var ui_owner: AttackTimerOwnerSelector.UiOwner


func _ready() -> void:
	owner_selector.ui_owner = ui_owner
