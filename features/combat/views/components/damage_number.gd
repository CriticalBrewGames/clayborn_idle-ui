extends Label
class_name DamageNumber


func setup(damage_amount: int, is_evaded: bool, _is_crit: bool = false) -> void:
	if is_evaded:
		text = tr("COMBAT_MISS")
		add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	else:
		text = str(damage_amount)
	
