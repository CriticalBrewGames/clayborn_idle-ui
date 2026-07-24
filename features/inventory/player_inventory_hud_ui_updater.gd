extends UIUpdaterBreakpoint

@onready var _quick_buttons: Control = $"../QuickAccessButtons"
@onready var _desktop_panel: Control = $"../DesktopPanel"


func _update_gui_bp(new_breakpoint: BreakpointsSchemas.Breakpoint) -> void:
	match new_breakpoint:
		BreakpointsSchemas.Breakpoint.SM, BreakpointsSchemas.Breakpoint.MD:
			if _quick_buttons:
				_quick_buttons.visible = true
			if _desktop_panel:
				_desktop_panel.visible = false
		_:
			if _quick_buttons:
				_quick_buttons.visible = false
			if _desktop_panel:
				_desktop_panel.visible = true
