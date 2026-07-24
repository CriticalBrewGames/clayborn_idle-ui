extends Panel

@export var plane_name: String = "Plane":
	set(value):
		plane_name = value
		if name_label:
			name_label.text = value

@export var tier: String = "T1":
	set(value):
		tier = value
		if tier_label:
			tier_label.text = value

@export var status: String = "Ready":
	set(value):
		status = value
		if status_label:
			status_label.text = value

@export var cargo: String = "8 slots":
	set(value):
		cargo = value
		if cargo_label:
			cargo_label.text = value

@onready var name_label: Label = $Margin/VBox/PlaneName
@onready var tier_label: Label = $Margin/VBox/MetaRow/TierLabel
@onready var status_label: Label = $Margin/VBox/MetaRow/StatusLabel
@onready var cargo_label: Label = $Margin/VBox/CargoLabel


func _ready() -> void:
	name_label.text = plane_name
	tier_label.text = tier
	status_label.text = status
	cargo_label.text = cargo
