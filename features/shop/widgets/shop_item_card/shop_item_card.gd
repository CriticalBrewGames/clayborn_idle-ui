extends Panel

signal buy_pressed

@export var item_name: String = "Copper Ore"
@export var price: int = 4
@export var stock_label: String = "∞"

@onready var name_label: Label = $Margin/VBox/ItemName
@onready var price_label: Label = $Margin/VBox/Price
@onready var stock: Label = $Margin/VBox/Footer/Stock
@onready var buy_button: Button = $Margin/VBox/Footer/BuyButton


func _ready() -> void:
	_apply()
	if buy_button:
		buy_button.pressed.connect(_on_buy_pressed)


func _apply() -> void:
	if name_label:
		name_label.text = item_name
	if price_label:
		price_label.text = "%d gold" % price
	if stock:
		stock.text = "stock %s" % stock_label


func _on_buy_pressed() -> void:
	buy_pressed.emit()
