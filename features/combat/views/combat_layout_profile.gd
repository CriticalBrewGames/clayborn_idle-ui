extends Node
class_name CombatLayoutProfile

@export_group("Player")
@export var player_hp_bar: ProgressBar
@export var player_sprite: TextureRect
@export var player_attack_bar: ExtendedProgressBar
@export var player_panel: Control
@export var player_container: Control
@export var player_sprite_panel: Control

@export_group("Enemy")
@export var enemy_hp_bar: ProgressBar
@export var enemy_sprite: TextureRect
@export var enemy_attack_bar: ExtendedProgressBar
@export var enemy_panel: Control
@export var enemy_container: Control
@export var enemy_sprite_panel: Control
@export var enemy_stats_panel: EnemyStatPanel
@export var enemy_attack_type: OffensiveTypeIcon
@export var enemy_name: Label

@export_group("Layout")
@export var base_container: Control
@export var cooldown_panel: Control
@export var countdown_container: BoxContainer
@export var friendly_cooldown_container: BoxContainer
@export var enemy_cooldown_container: BoxContainer
@export var middle_section: Control
@export var default_stat_panel: Control
@export var compact_stat_panel: Control
@export var combat_style_panel: Control
@export var str_button: BaseButton
@export var attack_button: BaseButton
@export var defence_button: BaseButton
@export var agility_button: BaseButton
