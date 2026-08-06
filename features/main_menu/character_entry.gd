class_name CharacterEntry extends Resource

enum GameMode {
	SOFTCORE,
	HARDCORE,
}

@export var id: StringName = &""
@export var character_name: String = ""
@export var mode: GameMode = GameMode.SOFTCORE


func mode_label() -> String:
	match mode:
		GameMode.HARDCORE:
			return "Hardcore"
		_:
			return "Softcore"


func display_label() -> String:
	return "%s - %s" % [character_name, mode_label()]
