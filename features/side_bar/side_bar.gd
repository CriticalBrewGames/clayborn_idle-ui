extends Control

## Side bar shell: layout only.
## Clicks: PayloadButtons under this tree are gathered by the parent InjectableScene.
## Skills: Main/SideBarScene pushes DTOs; we forward to SkillBar.

@onready var skill_bar: Control = $SkillBar


func apply_skills(skills: Array) -> void:
	skill_bar.apply_skills(skills)


func apply_skill(data: Dictionary) -> void:
	skill_bar.apply_skill(data)


func set_skill_level(skill_id: String, level: int) -> void:
	skill_bar.set_skill_level(skill_id, level)


func set_skill_xp(skill_id: String, xp: float) -> void:
	skill_bar.set_skill_xp(skill_id, xp)
