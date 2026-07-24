extends Panel

## Visual effect icon. Main binds display data via Dictionary — no Core types.

@onready var texture_rect: TextureRect = $TextureRect
@onready var stack_label: Label = $Stack
@onready var progress_bar: TextureProgressBar = $Progress

## Opaque token Main uses to identify this icon when removing (any Variant key).
var effect_token: Variant = null

var _progress_value: float = 0.0
var _progress_max: float = 0.0
var _stack_display: String = ""


func _ready() -> void:
	stack_label.visible = false


## data keys: icon (Texture2D), progress (float), progress_max (float), stack (String)
func bind_display(data: Dictionary, token: Variant = null) -> void:
	effect_token = token
	if data.has("icon") and data["icon"] is Texture2D:
		texture_rect.texture = data["icon"]
	update_display(data)


func update_display(data: Dictionary) -> void:
	_progress_value = float(data.get("progress", 0.0))
	_progress_max = float(data.get("progress_max", 0.0))
	_stack_display = str(data.get("stack", ""))

	if _progress_max > 0.0:
		progress_bar.max_value = _progress_max
		progress_bar.value = _progress_value
		progress_bar.visible = true
	else:
		progress_bar.visible = false

	if _stack_display != "":
		stack_label.text = _stack_display
		stack_label.visible = true
	else:
		stack_label.visible = false
