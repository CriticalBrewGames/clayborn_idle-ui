class_name BreakpointsSchemas extends Node


enum Breakpoint {
	SM,
	MD,
	LG,
	XL,
	XXL
}

static var BREAKPOINTS: Dictionary = {
	Breakpoint.SM: 640,
	Breakpoint.MD: 768,
	Breakpoint.LG: 1024,
	Breakpoint.XL: 1280,
	Breakpoint.XXL: 1563,
}
