extends Control

## Side bar skill binding. Main pushes Dictionary skill data.

signal skill_selected(skill_id: String)

@onready var skill_box: BoxContainer = $Panel/SkillBoxContainer


## skills: Array of Dictionaries or Dictionary keyed by skill_id.
## Each entry: { skill_id, name, level, xp, icon }
func update_skills(skills) -> void:
	var list: Array = []
	if skills is Dictionary:
		for key in skills.keys():
			var entry = skills[key]
			if entry is Dictionary:
				var copy: Dictionary = entry.duplicate()
				if not copy.has("skill_id"):
					copy["skill_id"] = str(key)
				list.append(copy)
	elif skills is Array:
		list = skills
	else:
		return

	var buttons := _collect_skill_buttons()
	for i in range(mini(list.size(), buttons.size())):
		var btn = buttons[i]
		if btn.has_method("update_from_data"):
			btn.update_from_data(list[i])


func update_skill(skill_id: String, data: Dictionary) -> void:
	for btn in _collect_skill_buttons():
		var btn_id := str(btn.skill_id) if "skill_id" in btn else ""
		if btn_id == skill_id or (data.has("skill_id") and str(data["skill_id"]) == btn_id):
			if btn.has_method("update_from_data"):
				var merged: Dictionary = data.duplicate()
				merged["skill_id"] = skill_id
				btn.update_from_data(merged)
			return


func set_skill_level(skill_id: String, level: int) -> void:
	update_skill(skill_id, {"level": level})


func set_skill_xp(skill_id: String, xp: float) -> void:
	update_skill(skill_id, {"xp": xp})


func _ready() -> void:
	for btn in _collect_skill_buttons():
		if btn.has_signal("skill_pressed"):
			if not btn.skill_pressed.is_connected(_on_skill_pressed):
				btn.skill_pressed.connect(_on_skill_pressed)


func _on_skill_pressed(skill_id: String) -> void:
	skill_selected.emit(skill_id)


func _collect_skill_buttons() -> Array:
	var result: Array = []
	if not skill_box:
		return result
	for group in skill_box.get_children():
		if group is VBoxContainer:
			for child in group.get_children():
				if child is Button and child.has_method("update_from_data"):
					result.append(child)
				elif child is Button and child.get_script() != null:
					result.append(child)
	return result
