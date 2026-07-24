extends HBoxContainer

signal mode_changed(mode: StringName)

const MODE_DISCOVERY := &"discovery"
const MODE_COMBINATOR := &"combinator"
const MODE_ENCHANTMENTS := &"enchantments"

@onready var discovery_btn: Button = $DiscoveryBtn
@onready var combinator_btn: Button = $CombinatorBtn
@onready var enchantments_btn: Button = $EnchantmentsBtn


func _ready() -> void:
	discovery_btn.toggled.connect(_on_toggled.bind(MODE_DISCOVERY))
	combinator_btn.toggled.connect(_on_toggled.bind(MODE_COMBINATOR))
	enchantments_btn.toggled.connect(_on_toggled.bind(MODE_ENCHANTMENTS))

	if combinator_btn.button_pressed:
		mode_changed.emit(MODE_COMBINATOR)
	elif discovery_btn.button_pressed:
		mode_changed.emit(MODE_DISCOVERY)
	elif enchantments_btn.button_pressed:
		mode_changed.emit(MODE_ENCHANTMENTS)


func _on_toggled(pressed: bool, mode: StringName) -> void:
	if pressed:
		mode_changed.emit(mode)
