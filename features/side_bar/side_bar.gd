extends Control

## Top-level side bar binding facade.

signal skill_selected(skill_id: String)

@onready var skill_bar: Control = $SkillBar


func _ready() -> void:
	if skill_bar and skill_bar.has_signal("skill_selected"):
		skill_bar.skill_selected.connect(func(id): skill_selected.emit(id))


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
