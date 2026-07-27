class_name BestiarySampleCatalog
extends RefCounted


static func _milestone(kills: int, label: String, lore: String, bonus: float) -> BestiaryMilestone:
	var milestone := BestiaryMilestone.new()
	milestone.kills = kills
	milestone.label = label
	milestone.lore = lore
	milestone.damage_bonus_pct = bonus
	return milestone


static func _milestones(items: Array) -> Array[BestiaryMilestone]:
	var out: Array[BestiaryMilestone] = []
	for item in items:
		out.append(item as BestiaryMilestone)
	return out


static func _entry(
	id: String,
	display_name: String,
	level: int,
	region: String,
	style: String,
	kills: int,
	hp: int,
	armour: int,
	attack: int,
	attack_speed: float,
	sprite_path: String,
	milestones: Array[BestiaryMilestone],
) -> BestiaryEntry:
	var entry := BestiaryEntry.new()
	entry.id = id
	entry.display_name = display_name
	entry.level = level
	entry.region = region
	entry.style = style
	entry.kills = kills
	entry.hp = hp
	entry.armour = armour
	entry.attack = attack
	entry.attack_speed = attack_speed
	if ResourceLoader.exists(sprite_path):
		entry.sprite = load(sprite_path) as Texture2D
	entry.milestones = milestones
	return entry


static func build() -> Array[BestiaryEntry]:
	var entries: Array[BestiaryEntry] = []

	entries.append(
		_entry(
			"treant_sapling",
			"Treant Sapling",
			3,
			"Mosswood",
			"Melee",
			47,
			260,
			30,
			16,
			1.8,
			"res://assets/monsters/forrest/treant_sapling.webp",
			_milestones([
				_milestone(
					10,
					"First Contact",
					"The saplings wake when axes bite too deep. Soft bark, hard roots — they fight like frightened children of the grove.",
					2.0
				),
				_milestone(
					50,
					"Root Memory",
					"Each sapling shares a pulse through the undergrowth. Kill enough and the forest starts to remember your footsteps.",
					5.0
				),
				_milestone(
					150,
					"Grove Whisper",
					"Old Treants send the young ahead as scouts. Their fear is not of death — it is of failing the canopy that raised them.",
					10.0
				),
				_milestone(
					500,
					"Bark Tithe",
					"Hunters who master the saplings learn where the wood bleeds sap, and where a single cut ends the fight.",
					18.0
				),
			])
		)
	)

	entries.append(
		_entry(
			"moss_giant",
			"Moss Giant",
			18,
			"Mosswood",
			"Melee",
			12,
			1840,
			95,
			42,
			2.4,
			"res://assets/monsters/forrest/moss_golem.webp",
			_milestones([
				_milestone(
					5,
					"Stone Footfalls",
					"You hear them before you see them — earth grinding under moss-wrapped ankles.",
					3.0
				),
				_milestone(
					25,
					"Green Hide",
					"Moss is not decoration. It softens blows and hides the seams between ancient stone plates.",
					7.0
				),
				_milestone(
					100,
					"Heartwood Core",
					"Beneath the moss lies a living core. Strike true, and the giant folds like a felled tower.",
					14.0
				),
				_milestone(
					300,
					"Titan’s Debt",
					"The grove keeps count. Those who fell many giants walk lighter through Mosswood — or so the scouts claim.",
					22.0
				),
			])
		)
	)

	entries.append(
		_entry(
			"cave_rat",
			"Cave Rat",
			1,
			"Copper Depths",
			"Skirmisher",
			312,
			40,
			4,
			6,
			1.1,
			"res://assets/monsters/mine/rat.webp",
			_milestones([
				_milestone(
					25,
					"Squeaks",
					"They nest in the spoil piles. A nuisance until the swarm learns your scent.",
					2.0
				),
				_milestone(
					100,
					"Tunnel Sense",
					"Rats mark the weak tunnels. Follow their paths and you find both ore veins and ambushes.",
					6.0
				),
				_milestone(
					250,
					"Pack Leader",
					"Larger rats drive the pack. Drop the leader and the rest scatter into the dark.",
					12.0
				),
				_milestone(
					1000,
					"Depths Familiar",
					"Miners tip their hats to anyone who culls a thousand. The shafts stay quieter for a while.",
					20.0
				),
			])
		)
	)

	entries.append(
		_entry(
			"sea_serpent",
			"Sea Serpent",
			32,
			"Brine Coast",
			"Magic",
			0,
			4200,
			70,
			68,
			2.0,
			"res://assets/monsters/sea/sea_serpent.webp",
			_milestones([
				_milestone(
					1,
					"First Scale",
					"Unseen until the water parts. One kill proves the legends are not tavern talk.",
					4.0
				),
				_milestone(
					15,
					"Salt Wound",
					"Its coils leave brine scars on hull and shore. Study the pattern and you can predict the strike.",
					9.0
				),
				_milestone(
					60,
					"Tide Memory",
					"Serpents return on the same tide. Coastal hunters set traps where the foam runs thickest.",
					16.0
				),
				_milestone(
					200,
					"Deep Crown",
					"Only those who bleed the deep enough learn where the serpent’s soft throat lies.",
					25.0
				),
			])
		)
	)

	entries.append(
		_entry(
			"forrest_bug",
			"Forest Bug",
			5,
			"Mosswood",
			"Skirmisher",
			88,
			120,
			18,
			12,
			1.3,
			"res://assets/monsters/forrest/forest_bug.webp",
			_milestones([
				_milestone(
					20,
					"Chitin Click",
					"They announce themselves with a dry click in the underbrush — then leap for the eyes.",
					2.0
				),
				_milestone(
					75,
					"Shell Crack",
					"The carapace is toughest along the back. Flip them, and the fight ends fast.",
					6.0
				),
				_milestone(
					200,
					"Hive Trail",
					"Bugs leave a faint scent trail to their nests. Hunters bottle it as lure — and as warning.",
					11.0
				),
				_milestone(
					600,
					"Brood Cleared",
					"Clear enough nests and the forest floor goes quiet. For a season, at least.",
					18.0
				),
			])
		)
	)

	return entries
