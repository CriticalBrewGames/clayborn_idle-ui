extends HBoxContainer

signal category_changed(category: StringName)

const CATEGORY_MINING := &"mining"
const CATEGORY_SMITHING := &"smithing"
const CATEGORY_COOKING := &"cooking"
const CATEGORY_HERBLORE := &"herblore"
const CATEGORY_ATTACK := &"attack"
const CATEGORY_DEFENCE := &"defence"

@onready var mining_btn: Button = $MiningBtn
@onready var smithing_btn: Button = $SmithingBtn
@onready var cooking_btn: Button = $CookingBtn
@onready var herblore_btn: Button = $HerbloreBtn
@onready var attack_btn: Button = $AttackBtn
@onready var defence_btn: Button = $DefenceBtn


func _ready() -> void:
	mining_btn.toggled.connect(_on_toggled.bind(CATEGORY_MINING))
	smithing_btn.toggled.connect(_on_toggled.bind(CATEGORY_SMITHING))
	cooking_btn.toggled.connect(_on_toggled.bind(CATEGORY_COOKING))
	herblore_btn.toggled.connect(_on_toggled.bind(CATEGORY_HERBLORE))
	attack_btn.toggled.connect(_on_toggled.bind(CATEGORY_ATTACK))
	defence_btn.toggled.connect(_on_toggled.bind(CATEGORY_DEFENCE))

	if mining_btn.button_pressed:
		category_changed.emit(CATEGORY_MINING)


func _on_toggled(pressed: bool, category: StringName) -> void:
	if pressed:
		category_changed.emit(category)
