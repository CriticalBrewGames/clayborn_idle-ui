extends Panel

@onready var art: TextureRect = $Margin/VBox/ArtFrame/Art
@onready var placeholder: Label = $Margin/VBox/ArtFrame/Placeholder
@onready var caption: Label = $Margin/VBox/Caption


func bind_entry(entry: BestiaryEntry) -> void:
	var discovered := entry.is_discovered()
	if art:
		art.texture = entry.sprite if discovered else null
		art.visible = discovered and entry.sprite != null
	if placeholder:
		placeholder.visible = not (discovered and entry.sprite != null)
		placeholder.text = "Defeat to reveal" if not discovered else "No art"
	if caption:
		caption.text = entry.id if discovered else "undiscovered"
