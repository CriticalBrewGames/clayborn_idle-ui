extends Panel

## Discovery panel wiring hooks. Emits generic signals — Main owns ItemStack logic.

signal slot_changed(slot_id: String, occupied: bool)
signal discover_pressed
signal status_message_changed(message: String)

@onready var base_slot: Control = $Margin/VBox/SlotsRow/BaseColumn/BaseSlot
@onready var result_slot: Control = $Margin/VBox/SlotsRow/ResultColumn/ResultSlot
@onready var discover_button: Button = $Margin/VBox/DiscoverButton
@onready var status_label: Label = $Margin/VBox/StatusPanel/StatusLabel
@onready var stats_body: Label = $Margin/VBox/UnlockStatsPanel/StatsMargin/StatsVBox/StatsBody

var _slot_occupied: Dictionary = {
	"base": false,
	"result": false,
}


func _ready() -> void:
	if discover_button:
		discover_button.pressed.connect(_on_discover_pressed)
	if base_slot:
		base_slot.set_meta("slot_id", "base")
	if result_slot:
		result_slot.set_meta("slot_id", "result")


func set_slot_occupied(slot_id: String, occupied: bool) -> void:
	_slot_occupied[slot_id] = occupied
	slot_changed.emit(slot_id, occupied)
	_refresh_status()


func get_slot_host(slot_id: String) -> Control:
	match slot_id:
		"base":
			return base_slot
		"result":
			return result_slot
		_:
			return null


func set_status(message: String) -> void:
	if status_label:
		status_label.text = message
	status_message_changed.emit(message)


func set_stats_preview(text: String) -> void:
	if stats_body:
		stats_body.text = text


func _on_discover_pressed() -> void:
	discover_pressed.emit()


func _refresh_status() -> void:
	if _slot_occupied.get("base", false):
		set_status(tr("CRAFTING_STATUS_READY_DISCOVER"))
	else:
		set_status(tr("CRAFTING_STATUS_PLACE_BASE"))
