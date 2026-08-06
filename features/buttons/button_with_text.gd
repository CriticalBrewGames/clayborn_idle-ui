class_name ExtraLabelButton extends PayloadButton


# The default button offset the text when inner shadow added
# This scene uses an extra button node, to fix this problem

@export var label_text: String

@onready var label: Label = $Label


func _ready() -> void:
	label.text = label_text
