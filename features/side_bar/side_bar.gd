extends Control

## Top-level side bar. Bubbles small StringName payloads from skill / utility / bottom buttons.
## Main routes payloads; this scene never opens scenes itself.

signal payload_pressed(payload: StringName)

@onready var skill_bar: Control = $SkillBar
@onready var utility_buttons: Control = $UtilityButtons
@onready var bottom_container: Control = $ButtomButtonContainer


func _ready() -> void:
	if skill_bar and skill_bar.has_signal("payload_pressed"):
		skill_bar.payload_pressed.connect(_forward_payload)
	_wire_payload_buttons(utility_buttons)
	_wire_payload_buttons(bottom_container)


func update_skills(skills) -> void:
	if skill_bar and skill_bar.has_method("update_skills"):
		skill_bar.update_skills(skills)


func update_skill(skill_id: String, data: Dictionary) -> void:
	if skill_bar and skill_bar.has_method("update_skill"):
		skill_bar.update_skill(skill_id, data)


func set_skill_level(skill_id: String, level: int) -> void:
	if skill_bar and skill_bar.has_method("set_skill_level"):
		skill_bar.set_skill_level(skill_id, level)


func set_skill_xp(skill_id: String, xp: float) -> void:
	if skill_bar and skill_bar.has_method("set_skill_xp"):
		skill_bar.set_skill_xp(skill_id, xp)


func _wire_payload_buttons(root: Node) -> void:
	if root == null:
		return
	if root.has_signal("payload_pressed"):
		if not root.payload_pressed.is_connected(_forward_payload):
			root.payload_pressed.connect(_forward_payload)
	if root is BaseButton and root.has_signal("payload_pressed"):
		if not root.payload_pressed.is_connected(_forward_payload):
			root.payload_pressed.connect(_forward_payload)
	for child in root.get_children():
		_wire_payload_buttons(child)


func _forward_payload(payload: StringName) -> void:
	payload_pressed.emit(payload)
