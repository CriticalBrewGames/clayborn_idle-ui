extends Control

## Side bar shell: layout only.
## Clicks: PayloadButtons under this tree are gathered by the parent InjectableScene.
## Skills: Main/SideBarScene pushes DTOs; we forward to SkillBar.

@onready var skill_bar: Control = $SkillBar


func apply_skills(skills: Array) -> void:
	if skill_bar and skill_bar.has_method("apply_skills"):
		skill_bar.apply_skills(skills)
	elif skill_bar and skill_bar.has_method("update_skills"):
		skill_bar.update_skills(skills)


func apply_skill(data: Dictionary) -> void:
	if skill_bar and skill_bar.has_method("apply_skill"):
		skill_bar.apply_skill(data)
	elif skill_bar and skill_bar.has_method("update_skill"):
		var skill_id := str(data.get("skill_id", ""))
		skill_bar.update_skill(skill_id, data)


func set_skill_level(skill_id: String, level: int) -> void:
	if skill_bar and skill_bar.has_method("set_skill_level"):
		skill_bar.set_skill_level(skill_id, level)


func set_skill_xp(skill_id: String, xp: float) -> void:
	if skill_bar and skill_bar.has_method("set_skill_xp"):
		skill_bar.set_skill_xp(skill_id, xp)


## Back-compat for current SideBarScene.
func update_skills(skills) -> void:
	if skills is Array:
		apply_skills(skills)
	elif skill_bar and skill_bar.has_method("update_skills"):
		skill_bar.update_skills(skills)


func update_skill(skill_id: String, data: Dictionary) -> void:
	var merged := data.duplicate()
	merged["skill_id"] = skill_id
	apply_skill(merged)
