extends Node
class_name TimeUtils


static func time_conversion(time_in_sec: float, start_value: float = -1) -> String:
	if start_value == -1:
		start_value = time_in_sec

	if time_in_sec < 1 and start_value < 1:
		return TranslationServer.translate("COMBAT_TIME_SEC_FRAC") % [time_in_sec]

	if start_value < 1 or (start_value < 10 and int(start_value) != start_value):
		if time_in_sec < 10:
			return TranslationServer.translate("COMBAT_TIME_SEC_FRAC") % [time_in_sec]

	var ceiling_second: int = ceili(time_in_sec)
	var seconds: int = ceiling_second % 60
	var minutes: int = int(ceiling_second / 60) % 60
	var hours: int = int(ceiling_second / 3600)

	if hours:
		return TranslationServer.translate("COMBAT_TIME_HMS") % [hours, minutes, seconds]
	if minutes:
		return TranslationServer.translate("COMBAT_TIME_MS") % [minutes, seconds]
	if seconds < 10:
		return TranslationServer.translate("COMBAT_TIME_SECONDS") % [seconds]
	return TranslationServer.translate("COMBAT_TIME_SECONDS_PADDED") % [seconds]
