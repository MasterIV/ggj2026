extends Node

enum BuffRarity {
	COMMON,
	RARE,
	LEGENDARY
}

func rarity_to_string(rarity: BuffRarity) -> String:
	return {
		BuffRarity.COMMON: "common",
		BuffRarity.RARE: "rare",
		BuffRarity.LEGENDARY: "legendary"
	}[rarity]

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
	NOVA,
	ARTILLERY,
	NONE
}

func attack_type_to_string(attack_type: AttackType) -> String:
	return {
		AttackType.PROJECTILE: "projectile",
		AttackType.CONE: "cone",
		AttackType.NOVA: "nova",
		AttackType.ARTILLERY: "artillery"
	}[attack_type]

func get_random_buff_of_rarity_and_element(rarity: BuffRarity, element: Element) -> Array:
	var all_buffs = get_all_buffs()
	var filtered_buffs = []
	for buff in all_buffs:
		if buff.rarety == rarity and (buff.damage_type == element || buff.damage_type == Element.NONE):
			filtered_buffs.append(buff)

	if filtered_buffs.size() == 0 && rarity == BuffRarity.LEGENDARY:
		return get_random_buff_of_rarity_and_element(BuffRarity.RARE, element)
	elif filtered_buffs.size() == 0 && rarity == BuffRarity.RARE:
		return get_random_buff_of_rarity_and_element(BuffRarity.COMMON, element)

	return filtered_buffs

func get_random_buff_for_element(element: Element):
	var buffs: Array
	var rand: int = randi() % 100 + 1

	if rand <= 80:
		buffs = get_random_buff_of_rarity_and_element(BuffRarity.COMMON, element)
	elif rand <= 95:
		buffs = get_random_buff_of_rarity_and_element(BuffRarity.RARE, element)
	else:
		buffs = get_random_buff_of_rarity_and_element(BuffRarity.LEGENDARY, element)

	if buffs.size() == 0:
		return null

	return buffs[randi() % buffs.size()]

func get_all_buffs():
	return [
		# Healing potions
		HealBuff.new("Healing Potion 5", 5, Element.NONE).rarity(BuffRarity.RARE),
		HealBuff.new("Healing Potion 10", 10, Element.NONE).rarity(BuffRarity.LEGENDARY),

		# AQUA PRIMARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Element.AQUA, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Shots Boost", 0, 0, 0, Element.AQUA, 0, 1).rarity(BuffRarity.LEGENDARY),

		# AQUA SECONDARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Waterwall Damage Boost", 0, 0.2, 0, Element.AQUA, 0, 0),
		ProjectileBuff.new("Waterwall Speed Boost", 0.2, 0, 0, Element.AQUA, 0, 0),

		# FIRE PRIMARY
		# Damage, Speed
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Element.FIRE),

		# FIRE SECONDARY
		# Damage, Radius, Speed
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Element.FIRE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Element.FIRE).rarity(BuffRarity.RARE),


		# NATURE PRIMARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Roots Damage Boost", 0, 0.15, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Roots Speed Boost", 0.15, 0, 0, Element.NATURE, 0, 0),
		ProjectileBuff.new("Roots Piercing Boost", 0, 0, 0, Element.NATURE, 1, 0).rarity(BuffRarity.RARE),
		ProjectileBuff.new("Roots Shots Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),

		# NATURE SECONDARY
		# Damage, Radius, Speed
		NovaBuff.new("Seed Bomb Damage Boost", 0.2, 0, 0, Element.NATURE),
		NovaBuff.new("Seed Bomb Radius Boost", 0, 0, 0.2, Element.NATURE),
		ProjectileBuff.new("Seed Bomb Fragments Boost", 0, 0, 0, Element.NATURE, 0, 1).rarity(BuffRarity.RARE),
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

class Buff:
	var rarety: BuffRarity = BuffRarity.COMMON
	var name: String
	var damage_type: Element # technically element type, shitty name
	var attack_type: AttackType = AttackType.NONE

	func rarity(new_rarity: BuffRarity) -> Buff:
		rarety = new_rarity
		return self

	func get_rarity_description() -> String:
		return Enums.rarity_to_string(rarety) + " buff"

	func get_description():
		assert(false, "get_description() must be overridden in subclasses")

class HealBuff extends Buff:
	var heal_amount: int

	func _init(new_name: String, new_heal_amount: int, element_type: Element = Enums.Element.NONE):
		name = new_name
		heal_amount = new_heal_amount
		damage_type = element_type

	func get_description() -> String:
		var desc = ""

		if heal_amount != 0:
			desc += "Heals for " + str(heal_amount) + " HP\n"

		return desc.strip_edges()

class ProjectileBuff extends Buff:
	var speed_multiplier: float
	var damage_multiplier: float
	var cooldown_multiplier: float
	var piercing: int = 0
	var shots_added: int = 0

	func _init(new_name: String, new_speed_multiplier: float, new_damage_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Element, new_piercing: int = 0, new_shots_added = 0):
		name = new_name
		speed_multiplier = new_speed_multiplier
		damage_multiplier = new_damage_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type
		piercing = new_piercing
		shots_added = new_shots_added
		attack_type = AttackType.PROJECTILE

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc += "Increases damage by " + str((damage_multiplier * 100)) + "%\n"
		if speed_multiplier != 0:
			desc += "Increases speed by " + str((speed_multiplier * 100)) + "%\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier * 100)) + "%\n"
		if piercing > 0:
			desc += "Grants piercing through " + str(piercing) + " enemies.\n"
		if shots_added > 0:
			desc += "Adds " + str(shots_added) + " additional projectiles per attack"

		return desc.strip_edges()

class ConeBuff extends Buff:
	var damage_multiplier: float
	var damage_interval_multiplier: float

	func _init(new_name: String, new_damage_multiplier: float, new_damage_interval_multiplier: float, new_damage_type: Element):
		name = new_name
		damage_multiplier = new_damage_multiplier
		damage_interval_multiplier = new_damage_interval_multiplier
		damage_type = new_damage_type
		attack_type = AttackType.CONE

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier * 100)) + "%\n"
		if damage_interval_multiplier != 0:
			desc += "Decreases damage interval by " + str((damage_interval_multiplier * 100)) + "%\n"

		return desc.strip_edges()

class ArtilleryBuff extends Buff:
	var speed_multiplier: float
	var cooldown_multiplier: float

	func _init(new_name: String, new_speed_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Element):
		name = new_name
		new_speed_multiplier = new_speed_multiplier
		new_cooldown_multiplier = new_cooldown_multiplier
		AttackType.ARTILLERY

	func get_description() -> String:
		var desc = ""

		if speed_multiplier != 0:
			desc = "Increases projectile speed by " + str((speed_multiplier * 100)) + "%\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier * 100)) + "%\n"

		return desc.strip_edges()


class NovaBuff extends Buff:
	var damage_multiplier: float
	var radius_multiplier: float
	var cooldown_multiplier: float

	func _init(new_name: String, new_damage_multiplier: float, new_radius_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Element):
		name = new_name
		damage_multiplier = new_damage_multiplier
		radius_multiplier = new_radius_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type
		attack_type = AttackType.NOVA

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier * 100)) + "%\n"
		if radius_multiplier != 0:
			desc += "Increases radius by " + str((radius_multiplier * 100)) + "%\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier * 100)) + "%\n"

		return desc.strip_edges()

func get_projectile_wall_position(center_pos: Vector2, shoot_direction: Vector2, index: int, total_count: int, spacing: float) -> Vector2:
	var perpendicular: Vector2 = Vector2(-shoot_direction.y, shoot_direction.x)
	var total_width: float = (total_count - 1) * spacing
	var start_offset: float = -total_width / 2.0
	var offset: float = start_offset + (index * spacing)
	return center_pos + (perpendicular * offset)

func get_direction_rotation(direction: Vector2) -> float:
	return direction.angle()
