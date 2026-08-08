extends Control

## Skill bar view. Main pushes SkillDto-shaped data; clicks are PayloadButtons
## gathered by the parent InjectableScene (no payload_pressed bubbling here).
##
## DTO keys: skill_id (StringName/String), name, level, xp, icon (Texture2D)

@onready var skill_box: BoxContainer = $Panel/SkillBoxContainer


## Full / initial bind. Matches each DTO to a button by skill_id ↔ payload.
func apply_skills(skills: Array) -> void:
	for entry in skills:
		var data := _as_skill_dict(entry)
		if data.is_empty():
			continue
		var skill_id := _skill_id_of(data)
		if skill_id.is_empty():
			continue
		apply_skill(data)


## Partial or full update for one skill (id required).
func apply_skill(data: Dictionary) -> void:
	var skill_id := _skill_id_of(data)
	if skill_id.is_empty():
		return
	var btn := _find_button(skill_id)
	if btn == null:
		return
	if btn.has_method("update_from_data"):
		var merged := data.duplicate()
		merged["skill_id"] = skill_id
		btn.update_from_data(merged)


func set_skill_level(skill_id: String, level: int) -> void:
	apply_skill({"skill_id": skill_id, "level": level})


func set_skill_xp(skill_id: String, xp: float) -> void:
	apply_skill({"skill_id": skill_id, "xp": xp})


## Back-compat aliases used by current SideBarScene / SideBar.
func update_skills(skills) -> void:
	var list: Array = []
	if skills is Dictionary:
		for key in skills.keys():
			var entry = skills[key]
			var data := _as_skill_dict(entry)
			if data.is_empty():
				continue
			if not data.has("skill_id"):
				data["skill_id"] = str(key)
			list.append(data)
	elif skills is Array:
		for entry in skills:
			var data := _as_skill_dict(entry)
			if not data.is_empty():
				list.append(data)
	else:
		return
	apply_skills(list)


func update_skill(skill_id: String, data: Dictionary) -> void:
	var merged := data.duplicate()
	merged["skill_id"] = skill_id
	apply_skill(merged)


func _as_skill_dict(entry: Variant) -> Dictionary:
	if entry is Dictionary:
		return (entry as Dictionary).duplicate()
	# Optional: Resource DTO with to_dict() / exported fields
	if entry is Object and entry.has_method("to_dict"):
		var d = entry.to_dict()
		return d if d is Dictionary else {}
	return {}


func _skill_id_of(data: Dictionary) -> String:
	if data.has("skill_id"):
		return str(data["skill_id"])
	return ""


func _find_button(skill_id: String) -> Button:
	for btn in _collect_skill_buttons():
		var btn_id := ""
		if "payload" in btn:
			btn_id = str(btn.payload)
		elif "skill_id" in btn:
			btn_id = str(btn.skill_id)
		if btn_id == skill_id:
			return btn
	return null


func _collect_skill_buttons() -> Array:
	var result: Array = []
	if skill_box == null:
		return result
	for group in skill_box.get_children():
		if group is VBoxContainer:
			for child in group.get_children():
				if child is Button and ("payload" in child or child.has_method("update_from_data")):
					result.append(child)
	return result
