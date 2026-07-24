extends HBoxContainer

signal mode_changed(mode: StringName)

const MODE_BUY := &"buy"
const MODE_SELL := &"sell"

@onready var buy_btn: Button = $BuyBtn
@onready var sell_btn: Button = $SellBtn


func _ready() -> void:
	buy_btn.toggled.connect(_on_toggled.bind(MODE_BUY))
	sell_btn.toggled.connect(_on_toggled.bind(MODE_SELL))

	if buy_btn.button_pressed:
		mode_changed.emit(MODE_BUY)
	elif sell_btn.button_pressed:
		mode_changed.emit(MODE_SELL)


func _on_toggled(pressed: bool, mode: StringName) -> void:
	if pressed:
		mode_changed.emit(mode)
