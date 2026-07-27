extends Node
class_name CombatHudView

signal offensive_style_selected(style: int)
signal defensive_style_selected(style: int)

@export var layout_profile: CombatLayoutProfile

const _DamageNumberScene = preload("res://ui/features/combat/views/components/damage_number.tscn")


func _resolve_layout() -> void:
	if layout_profile == null:
		layout_profile = get_parent().get_node_or_null("CombatLayoutProfile") as CombatLayoutProfile


func bind_layout(profile: CombatLayoutProfile) -> void:
	layout_profile = profile


func set_player_hp(current: int, max_hp: int, reset: bool = false) -> void:
	_resolve_layout()
	if layout_profile and layout_profile.player_hp_bar and layout_profile.player_hp_bar.has_method("change_max_hp"):
		layout_profile.player_hp_bar.change_max_hp(max_hp, reset)
		layout_profile.player_hp_bar.modify_current_hp(current - layout_profile.player_hp_bar.current_hp)


func set_enemy_hp(current: int, max_hp: int, reset: bool = false) -> void:
	_resolve_layout()
	if layout_profile and layout_profile.enemy_hp_bar and layout_profile.enemy_hp_bar.has_method("change_max_hp"):
		layout_profile.enemy_hp_bar.change_max_hp(max_hp, reset)
		layout_profile.enemy_hp_bar.modify_current_hp(current - layout_profile.enemy_hp_bar.current_hp)


func set_player_attack_speed(seconds: float) -> void:
	_resolve_layout()
	if layout_profile and layout_profile.player_attack_bar:
		layout_profile.player_attack_bar.process_time = seconds


func set_enemy_attack_speed(seconds: float) -> void:
	_resolve_layout()
	if layout_profile and layout_profile.enemy_attack_bar:
		layout_profile.enemy_attack_bar.process_time = seconds


func show_heal(is_player: bool, amount: int) -> void:
	_resolve_layout()
	if layout_profile == null:
		return
	var hp_bar := layout_profile.player_hp_bar if is_player else layout_profile.enemy_hp_bar
	var sprite := layout_profile.player_sprite if is_player else layout_profile.enemy_sprite
	if hp_bar and hp_bar.has_method("modify_current_hp"):
		hp_bar.modify_current_hp(amount)
	if sprite:
		_flash_sprite(sprite)


func show_damage(is_player: bool, amount: int, is_evaded: bool, is_crit: bool = false) -> void:
	_resolve_layout()
	if layout_profile == null:
		return
	var hp_bar := layout_profile.player_hp_bar if is_player else layout_profile.enemy_hp_bar
	var sprite := layout_profile.player_sprite if is_player else layout_profile.enemy_sprite
	var panel := layout_profile.player_panel if is_player else layout_profile.enemy_panel
	if hp_bar and hp_bar.has_method("modify_current_hp") and not is_evaded:
		hp_bar.modify_current_hp(-amount)
	if sprite:
		_flash_sprite(sprite)
	if panel:
		_spawn_damage_number(panel, amount, is_evaded, is_crit)


func set_enemy_display(
		enemy_name: String,
		sprite: Texture2D,
		stats: Dictionary,
		attack_style: OffensiveTypeIcon.DamageStyle,
		defense_style: EnemyStatPanel.DefenseStyle
) -> void:
	_resolve_layout()
	if layout_profile == null:
		return
	if layout_profile.enemy_container:
		layout_profile.enemy_container.visible = true
	if layout_profile.enemy_attack_type:
		layout_profile.enemy_attack_type.visible = true
		if layout_profile.enemy_attack_type.has_method("set_type_from_int"):
			layout_profile.enemy_attack_type.set_type_from_int(int(attack_style))
		elif layout_profile.enemy_attack_type.has_method("set_type"):
			layout_profile.enemy_attack_type.set_type(attack_style)
	if layout_profile.enemy_sprite:
		layout_profile.enemy_sprite.texture = sprite
	if layout_profile.enemy_name:
		layout_profile.enemy_name.text = enemy_name
	if layout_profile.enemy_stats_panel:
		pass
		#layout_profile.enemy_stats_panel.update_panel(stats, attack_style, defense_style)


func hide_enemy() -> void:
	_resolve_layout()
	if layout_profile == null:
		return
	if layout_profile.enemy_attack_type:
		layout_profile.enemy_attack_type.visible = false
	if layout_profile.enemy_container:
		layout_profile.enemy_container.visible = false


func _flash_sprite(target: TextureRect) -> void:
	var tween := create_tween()
	var original_color := Color(1, 1, 1, 1)
	tween.tween_property(target, "modulate", Color(1, 0.05, 0.05), 0.1)
	tween.tween_property(target, "modulate", original_color, 0.1)
	var original_pos := target.position
	tween.parallel().tween_property(target, "position", original_pos + Vector2(5, 0), 0.05)
	tween.parallel().tween_property(target, "position", original_pos - Vector2(5, 0), 0.05).set_delay(0.05)
	tween.parallel().tween_property(target, "position", original_pos, 0.05).set_delay(0.1)


func _spawn_damage_number(parent: Control, amount: int, is_evaded: bool, is_crit: bool) -> void:
	var damage_viz = _DamageNumberScene.instantiate()
	parent.add_child(damage_viz)
	var random_offset := randf_range(-30, 30)
	damage_viz.position = Vector2(parent.size.x / 2 + random_offset - 20, parent.size.y / 2)
	if damage_viz.has_method("setup"):
		damage_viz.setup(amount, is_evaded, is_crit)
