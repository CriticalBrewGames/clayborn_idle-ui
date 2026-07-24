extends Control

@onready var normal_sprite = $NormalDamage
@onready var critical_sprite = $CriticalDamage
@onready var damage_number = $DamageNumber

func setup(damage_amount: int, is_evaded: bool, is_crit: bool = false) -> void:
	if not is_evaded and not is_crit:
		normal_sprite.visible = true
	elif not is_evaded and is_crit:
		critical_sprite.visible = true
	
	damage_number.setup(damage_amount, is_evaded)
	
	# Start animation
	_animate()



func _animate() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Float upward
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.8).set_ease(Tween.EASE_OUT)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, 0.8).set_delay(0.2)
	
	# Scale pop effect
	scale = Vector2(0.5, 0.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Queue free after animation
	tween.chain().tween_callback(queue_free)
