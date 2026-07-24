extends Panel

@export var quest_name: String = "Tower of Gems"
@export var duration: String = "5 minute quest"
@export_multiline var description: String = "Activate the imbued gems in the correct order to open the barrier."
@export var status: String = "Available"
@export var action_label: String = "Start"
@export var show_progress: bool = false
@export var progress_value: float = 0.0
@export var locked: bool = false

@onready var name_label: Label = $Margin/VBox/TitlePanel/QuestName
@onready var duration_label: Label = $Margin/VBox/Body/Details/Duration
@onready var description_label: Label = $Margin/VBox/Body/Details/Description
@onready var status_label: Label = $Margin/VBox/Footer/Status
@onready var action_button: Button = $Margin/VBox/Footer/ActionButton
@onready var progress_bar: ProgressBar = $Margin/VBox/ProgressBar
@onready var lock_overlay: Panel = $LockOverlay


func _ready() -> void:
	_apply()


func _apply() -> void:
	if name_label:
		name_label.text = quest_name
	if duration_label:
		duration_label.text = duration
	if description_label:
		description_label.text = description
	if status_label:
		status_label.text = status
	if action_button:
		action_button.text = action_label
		action_button.disabled = locked
	if progress_bar:
		progress_bar.visible = show_progress
		progress_bar.value = progress_value
	if lock_overlay:
		lock_overlay.visible = locked
