extends Panel

signal buy_pressed

@export var item_name: String = "Copper Ore"
@export var price: int = 4
@export var stock_label: String = "∞"
@export var icon_texture: Texture2D

@onready var name_label: Label = $Margin/VBox/ItemName
@onready var price_label: Label = $Margin/VBox/Price
@onready var stock: Label = $Margin/VBox/Footer/Stock
@onready var buy_button: Button = $Margin/VBox/Footer/BuyButton
@onready var icon_rect: TextureRect = $Margin/VBox/IconPanel/Icon
@onready var icon_label: Label = $Margin/VBox/IconPanel/IconLabel


func _ready() -> void:
	_apply()
	if buy_button and not buy_button.pressed.is_connected(_on_buy_pressed):
		buy_button.pressed.connect(_on_buy_pressed)


func configure(new_name: String, new_price: int, texture: Texture2D = null, stock_text: String = "∞") -> void:
	item_name = new_name
	price = new_price
	icon_texture = texture
	stock_label = stock_text
	_apply()


func _apply() -> void:
	if name_label:
		name_label.text = item_name
	if price_label:
		price_label.text = tr("SHOP_PRICE_GOLD") % price
	if stock:
		stock.text = tr("SHOP_STOCK") % stock_label
	if icon_rect:
		icon_rect.texture = icon_texture
		icon_rect.visible = icon_texture != null
	if icon_label:
		icon_label.visible = icon_texture == null


func _on_buy_pressed() -> void:
	buy_pressed.emit()
