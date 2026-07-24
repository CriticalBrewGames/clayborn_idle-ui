extends UIUpdaterBreakpoint

const PROGRESS_BAR_SM_SIZE = Vector2(18, 90)
const PROGRESS_BAR_MD_SIZE = Vector2(90, 18)

const ROOT_SM_SIZE = Vector2(30, 165)
const ROOT_MD_SIZE = Vector2(125, 30)

@onready var root: BoxContainer = $".."
@onready var progress_bar: ExtendedProgressBar = $"../PlayerAttackBar"

@export var attack_type_selector: AttackTimerOwnerSelector

func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	var ui_owner = attack_type_selector.get_attack_timer_owner()
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM:
			root.vertical = true
			root.set_size(ROOT_SM_SIZE)
			root.custom_minimum_size = ROOT_SM_SIZE
			progress_bar.fill_mode = _get_fill_type_by_owner(new_breakpoint, ui_owner)
			progress_bar.custom_minimum_size = PROGRESS_BAR_SM_SIZE
			progress_bar.set_size(PROGRESS_BAR_SM_SIZE)
		BreakpointsSchemas.Breakpoint.MD:
			root.vertical = false
			root.set_size(ROOT_MD_SIZE)
			root.custom_minimum_size = ROOT_MD_SIZE
			progress_bar.fill_mode = _get_fill_type_by_owner(new_breakpoint, ui_owner)
			progress_bar.custom_minimum_size = PROGRESS_BAR_MD_SIZE
			progress_bar.set_size(PROGRESS_BAR_MD_SIZE)

func _get_fill_type_by_owner(
	new_breakpoint: BreakpointsSchemas.Breakpoint,
	owner_enum: AttackTimerOwnerSelector.UiOwner,
	) -> ProgressBar.FillMode:
	
	if owner_enum == AttackTimerOwnerSelector.UiOwner.PLAYER:
		match new_breakpoint:
			BreakpointsSchemas.Breakpoint.SM:
				return ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
			_:
				return ProgressBar.FillMode.FILL_BEGIN_TO_END
	elif owner_enum == AttackTimerOwnerSelector.UiOwner.ENEMY:
		match new_breakpoint:
			BreakpointsSchemas.Breakpoint.SM:
				return ProgressBar.FillMode.FILL_TOP_TO_BOTTOM
			_:
				return ProgressBar.FillMode.FILL_END_TO_BEGIN
	
	return ProgressBar.FillMode.FILL_BEGIN_TO_END 
