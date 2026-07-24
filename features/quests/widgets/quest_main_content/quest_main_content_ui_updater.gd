extends UIUpdaterContinuous

const QUEST_CARD_SIZE: float = 450.0
const TOLERANCE: float = 0.6

@onready var grid_container: GridContainer = $"../Panel/ScrollContainer/GridContainer"


func _update_gui_dynamic(_size: Vector2) -> void:
	if not is_instance_valid(grid_container):
		return

	var scroll_container := grid_container.get_parent() as Control
	var available_width: float = scroll_container.get_global_rect().size.x
	var h_separation: float = grid_container.get_theme_constant("h_separation")

	var raw_columns: float = (available_width + h_separation) / (QUEST_CARD_SIZE + h_separation)
	var calculated_columns: int = int(raw_columns + (1.0 - TOLERANCE))

	grid_container.columns = max(1, calculated_columns)
