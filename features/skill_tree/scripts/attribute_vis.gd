extends RichTextLabel

## Displays aggregated skill-tree attributes from Dictionary data.
## Main calls set_attributes(attribs, grand_descriptions).

var _attribs: Dictionary = {}
var _grand: Array = []


func set_attributes(attribs: Dictionary, grand_descriptions: Array = []) -> void:
	_attribs = attribs
	_grand = grand_descriptions
	_refresh()


func _refresh() -> void:
	var parts: PackedStringArray = []
	for key in _attribs.keys():
		var name := _format_attrib_names(str(key))
		parts.append("%s : %s%%" % [name, str(_attribs[key])])
	for desc in _grand:
		parts.append(str(desc))
	text = "\n".join(parts)


func _format_attrib_names(input_str: String) -> String:
	var words = input_str.split("_")
	var formatted: PackedStringArray = []
	for word in words:
		formatted.append(word.capitalize())
	return " ".join(formatted)
