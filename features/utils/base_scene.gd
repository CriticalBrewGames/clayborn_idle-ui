class_name SceneBase extends Node

signal destroy_request(scene_to_destroy: SceneBase)
signal delayed_destroy(scene: SceneBase)
## Emitted by content scenes that want the Router to open another payload.
signal new_page_request(payload: StringName, content_id: String)
signal action_request(action: StringName, content_id: String, parms: Dictionary)

var cache_policy: Route.CachePolicy = Route.CachePolicy.KEEP_IF_PROCESSING
var is_pending_destruction: bool = false

var _is_node_processing: bool = false
## When true, CacheManager keeps this scene cached instead of freeing it
## (KEEP_IF_PROCESSING policy). Finishing processing requests delayed destroy.
var is_node_processing: bool:
	get:
		return _is_node_processing
	set(value):
		var was_processing := _is_node_processing
		_is_node_processing = value
		if was_processing and not _is_node_processing:
			request_delayed_destroy()


func _ready() -> void:
	for node in get_children():
		if node is PayloadButton and node.button_export == true:
				match node.handleing:
					PayloadButton.Handleing.REQUEST:
						node.payload_pressed.connect(send_request)
					PayloadButton.Handleing.ACTION:
						node.action_request.connect(send_action)


func send_request(payload: StringName, content_id: String = ""):
	new_page_request.emit(payload, content_id)

func send_action(payload: StringName, content_id: String = "", parms: Dictionary = {}):
	action_request.emit(payload, content_id, parms)


func initialize_dependencies(dependencies: Dictionary):
	pass


func autostart(_content_id: String):
	pass


func start_processing() -> void:
	is_node_processing = true


func finish_processing() -> void:
	is_node_processing = false


func request_destroy() -> void:
	destroy_request.emit(self)


func request_delayed_destroy() -> void:
	delayed_destroy.emit(self)
