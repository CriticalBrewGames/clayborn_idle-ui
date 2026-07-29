class_name BestiaryEntry
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var level: int = 1
@export var region: String = ""
@export var style: String = "Melee"
@export var kills: int = 0
@export var hp: int = 0
@export var armour: int = 0
@export var attack: int = 0
@export var attack_speed: float = 1.0
@export var sprite: Texture2D
@export var milestones: Array[BestiaryMilestone] = []


func is_discovered() -> bool:
	return kills > 0


func unlocked_milestones() -> Array[BestiaryMilestone]:
	var out: Array[BestiaryMilestone] = []
	for milestone in milestones:
		if kills >= milestone.kills:
			out.append(milestone)
	return out


func next_milestone() -> BestiaryMilestone:
	for milestone in milestones:
		if kills < milestone.kills:
			return milestone
	return null


func total_damage_bonus_pct() -> float:
	var total := 0.0
	for milestone in unlocked_milestones():
		total += milestone.damage_bonus_pct
	return total


func mastery_kill_cap() -> int:
	if milestones.is_empty():
		return 1
	return milestones[milestones.size() - 1].kills


func progress_to_next() -> Dictionary:
	var unlocked := unlocked_milestones()
	var next := next_milestone()
	var prev_kills := 0
	if not unlocked.is_empty():
		prev_kills = unlocked[unlocked.size() - 1].kills

	if next == null:
		var cap := mastery_kill_cap()
		return {
			"current": kills,
			"target": cap,
			"pct": 100.0,
			"label": tr("BESTIARY_ALL_MILESTONES"),
			"next": null,
		}

	var span: float = maxf(1.0, float(next.kills - prev_kills))
	var into: float = float(kills - prev_kills)
	return {
		"current": kills,
		"target": next.kills,
		"pct": clampf((into / span) * 100.0, 0.0, 100.0),
		"label": tr("BESTIARY_NEXT_MILESTONE") % [next.label, next.kills],
		"next": next,
	}
