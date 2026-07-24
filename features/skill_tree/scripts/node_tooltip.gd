extends ColorRect


func set_tooltip(attribute_name: String, attribute_desc: String) -> void:
	var label = $RichTextLabel
	if attribute_name and attribute_desc and label:
		label.text = " [b] %s [/b] \n %s" % [attribute_name, attribute_desc]
