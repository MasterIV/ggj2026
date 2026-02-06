extends Node

enum BuffRarity {
	COMMON,
	RARE,
	LEGENDARY
}

enum ProjectileDirection {
	MOUSE,
	RANDOM
}

enum ProjectileShotType {
	LINE,
	ARC
}

enum Element {
	NONE,
	AQUA,
	FIRE,
	NATURE
}

enum AttackType {
	PROJECTILE,
	CONE,
	NOVA
}

func get_random_buff_for_element(element: Element):
	var buffs = get_all_buffs()
	var filtered_buffs = []
	for buff in buffs:
		match element:
			Element.AQUA:
				if buff.damage_type == Element.AQUA:
					filtered_buffs.append(buff)
			Element.FIRE:
				if buff.damage_type == Element.FIRE:
					filtered_buffs.append(buff)
			Element.NATURE:
				if buff.damage_type == Element.NATURE:
					filtered_buffs.append(buff)
	return filtered_buffs[randi() % filtered_buffs.size()]

func get_all_buffs():
	return [
		# AQUA PRIMARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Element.AQUA, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Element.AQUA, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Element.AQUA, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Shots Boost", 0, 0, 0, Element.AQUA, 0, 1).rarity(BuffRarity.LEGENDARY),

		# AQUA SECONDARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),

		# FIRE PRIMARY
		# Damage, Speed
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),

		# FIRE SECONDARY
		# Damage, Radius, Speed
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Element.FIRE).rarity(BuffRarity.RARE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Element.FIRE).rarity(BuffRarity.RARE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Element.FIRE).rarity(BuffRarity.RARE),


		# NATURE PRIMARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Piercing Boost", 0, 0, 0, Element.NATURE, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Piercing Boost", 0, 0, 0, Element.NATURE, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Piercing Boost", 0, 0, 0, Element.NATURE, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Shots Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Shots Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Shots Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),

		# NATURE SECONDARY
		# Damage, Radius, Speed
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		ProjectileBuff.new("Nature Seed Bomb Fragments Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Seed Bomb Fragments Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Nature Seed Bomb Fragments Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),
	]

func element_to_string(element: Element):
	return {
		Element.AQUA: "aqua",
		Element.FIRE: "fire",
		Element.NATURE: "nature"
	}[element]

func string_to_element(element: String):
	return {
		"aqua": Element.AQUA,
		"fire": Element.FIRE,
		"nature": Element.NATURE
	}[element]

class ProjectileBuff:
	var rarety: BuffRarity = BuffRarity.COMMON
	var name: String
	var speed_multiplier: float
	var damage_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Element
	var piercing: int = 0
	var attack_type = AttackType.PROJECTILE
	var shots_added: int = 0

	func _init(new_name: String, new_speed_multiplier: float, new_damage_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Element, new_piercing: int = 0, new_shots_added = 0):
		name = new_name
		speed_multiplier = new_speed_multiplier
		damage_multiplier = new_damage_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type
		piercing = new_piercing
		shots_added = new_shots_added

	func rarity(new_rarity: BuffRarity) -> ProjectileBuff:
		rarety = new_rarity
		return self

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc += "Increases damage by " + str((damage_multiplier)) + ".\n"
		if speed_multiplier != 0:
			desc += "Increases speed by " + str((speed_multiplier)) + ".\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier)) + ".\n"
		if piercing > 0:
			desc += "Grants piercing through " + str(piercing) + " enemies.\n"
		if shots_added > 0:
			desc += "Adds " + str(shots_added) + " additional projectiles per attack"

		return desc.strip_edges()

class ConeBuff:
	var rarety: BuffRarity = BuffRarity.COMMON
	var name: String
	var damage_multiplier: float
	var damage_interval_multiplier: float
	var damage_type: Element
	var attack_type = AttackType.CONE

	func _init(new_name: String, new_damage_multiplier: float, new_damage_interval_multiplier: float, new_damage_type: Element):
		name = new_name
		damage_multiplier = new_damage_multiplier
		damage_interval_multiplier = new_damage_interval_multiplier
		damage_type = new_damage_type

	func rarity(new_rarity: BuffRarity) -> ConeBuff:
		rarety = new_rarity
		return self

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if damage_interval_multiplier != 0:
			desc += "Decreases damage interval by " + str((damage_interval_multiplier)) + ".\n"

		return desc.strip_edges()

class NovaBuff:
	var rarety: BuffRarity = BuffRarity.COMMON
	var name: String
	var damage_multiplier: float
	var radius_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Element
	var attack_type = AttackType.NOVA

	func _init(new_name: String, new_damage_multiplier: float, new_radius_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Element):
		name = new_name
		damage_multiplier = new_damage_multiplier
		radius_multiplier = new_radius_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type

	func rarity(new_rarity: BuffRarity) -> NovaBuff:
		rarety = new_rarity
		return self

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if radius_multiplier != 0:
			desc += "Increases radius by " + str((radius_multiplier)) + ".\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier)) + ".\n"

		return desc.strip_edges()

func get_projectile_wall_position(center_pos: Vector2, shoot_direction: Vector2, index: int, total_count: int, spacing: float) -> Vector2:
	var perpendicular: Vector2 = Vector2(-shoot_direction.y, shoot_direction.x)
	var total_width: float = (total_count - 1) * spacing
	var start_offset: float = -total_width / 2.0
	var offset: float = start_offset + (index * spacing)
	return center_pos + (perpendicular * offset)

func get_direction_rotation(direction: Vector2) -> float:
	return direction.angle()
