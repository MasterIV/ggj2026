extends Node

func get_random_element() -> Enums.Element:
	var elements: Array[Enums.Element] = [Enums.Element.AQUA, Enums.Element.FIRE, Enums.Element.NATURE]
	return elements[randi() % elements.size()]

func get_random_attack_type() -> Enums.AttackType:
	var attack_types: Array[Enums.AttackType] = [Enums.AttackType.PROJECTILE, Enums.AttackType.CONE, Enums.AttackType.NOVA]
	return attack_types[randi() % attack_types.size()]

func get_random_buff_for_element(element: Enums.Element):
	var buffs = get_all_buffs()
	var filtered_buffs = []
	for buff in buffs:
		match element:
			Enums.Element.AQUA:
				if buff.damage_type == Enums.Element.AQUA:
					filtered_buffs.append(buff)
			Enums.Element.FIRE:
				if buff.damage_type == Enums.Element.FIRE:
					filtered_buffs.append(buff)
			Enums.Element.NATURE:
				if buff.damage_type == Enums.Element.NATURE:
					filtered_buffs.append(buff)
	return filtered_buffs[randi() % filtered_buffs.size()]

func get_random_buff_for_attack_type(attack_type: Enums.AttackType):
	var buffs = get_all_buffs()
	var filtered_buffs = []
	for buff in buffs:
		match attack_type:
			Enums.AttackType.PROJECTILE:
				if buff is ProjectileBuff:
					filtered_buffs.append(buff)
			Enums.AttackType.CONE:
				if buff is ConeBuff:
					filtered_buffs.append(buff)
			Enums.AttackType.NOVA:
				if buff is NovaBuff:
					filtered_buffs.append(buff)
	return filtered_buffs[randi() % filtered_buffs.size()]

func get_all_buffs():
	return [
		# AQUA PRIMARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Damage Boost", 0, 0.15, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Speed Boost", 0.15, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Enums.Element.AQUA, 1, 0).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Enums.Element.AQUA, 1, 0).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Piercing Boost", 0, 0, 0, Enums.Element.AQUA, 1, 0).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Aqua Lance Shots Boost", 0, 0, 0, Enums.Element.AQUA, 0, 1).rarity(Enums.BuffRarity.LEGENDARY),

		# AQUA SECONDARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Damage Boost", 0, 0.2, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Enums.Element.AQUA, 0, 0),
		ProjectileBuff.new("Aqua Wave Speed Boost", 0.2, 0, 0, Enums.Element.AQUA, 0, 0),

		# FIRE PRIMARY
		# Damage, Speed
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Damage, Boost", 0.15, 0, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Enums.Element.FIRE),
		ConeBuff.new("Fire Blast Speed, Boost", 0, 0.15, Enums.Element.FIRE),

		# FIRE SECONDARY
		# Damage, Radius, Speed
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Damage Boost", 0.2, 0, 0, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Speed Boost", 0, 0, 0.2, Enums.Element.FIRE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Enums.Element.FIRE).rarity(Enums.BuffRarity.RARE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Enums.Element.FIRE).rarity(Enums.BuffRarity.RARE),
		NovaBuff.new("Fire Nova Range Boost", 0, 0.2, 0, Enums.Element.FIRE).rarity(Enums.BuffRarity.RARE),


		# NATURE PRIMARY
		# Speed, Damage, Cooldown, Piercing, Projectile
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Damage Boost", 0, 0.15, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Speed Boost", 0.15, 0, 0, Enums.Element.NATURE, 0, 0),
		ProjectileBuff.new("Nature Roots Piercing Boost", 0, 0, 0, Enums.Element.NATURE, 1, 0).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Piercing Boost", 0, 0, 0, Enums.Element.NATURE, 1, 0).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Piercing Boost", 0, 0, 0, Enums.Element.NATURE, 1, 0).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Shots Boost", 0, 0, 0, Enums.Element.NATURE, 0, 1).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Shots Boost", 0, 0, 0, Enums.Element.NATURE, 0, 1).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Roots Shots Boost", 0, 0, 0, Enums.Element.NATURE, 0, 1).rarity(Enums.BuffRarity.RARE),

		# NATURE SECONDARY
		# Damage, Radius, Speed
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Damage Boost", 0.2, 0, 0, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Enums.Element.NATURE),
		NovaBuff.new("Nature Seed Bomb Radius Boost", 0, 0, 0.2, Enums.Element.NATURE),
		ProjectileBuff.new("Nature Seed Bomb Fragments Boost", 0, 0, 0, Enums.Element.NATURE, 0, 1).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Seed Bomb Fragments Boost", 0, 0, 0, Enums.Element.NATURE, 0, 1).rarity(Enums.BuffRarity.RARE),
		ProjectileBuff.new("Nature Seed Bomb Fragments Boost", 0, 0, 0, Enums.Element.NATURE, 0, 1).rarity(Enums.BuffRarity.RARE),
	]

class ProjectileBuff:
	var rarety: Enums.BuffRarity = Enums.BuffRarity.COMMON
	var name: String
	var speed_multiplier: float
	var damage_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Enums.Element
	var piercing: int = 0
	var attack_type = Enums.AttackType.PROJECTILE
	var shots_added: int = 0

	func _init(new_name: String, new_speed_multiplier: float, new_damage_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Enums.Element, new_piercing: int = 0, new_shots_added = 0):
		name = new_name
		speed_multiplier = new_speed_multiplier
		damage_multiplier = new_damage_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type
		piercing = new_piercing
		shots_added = new_shots_added

	func rarity(new_rarity: Enums.BuffRarity) -> ProjectileBuff:
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

class ProjectileBuffCollection:
	var buffs: Array = []
	var speed_multiplier: float
	var damage_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Enums.Element
	var piercing: int = 0
	var attack_type = Enums.AttackType.PROJECTILE
	var shots_added: int = 0

	func _init(new_buffs: Array, damageType: Enums.Element):
		buffs = new_buffs
		damage_type = damageType

		for buff in buffs:
			damage_multiplier += buff.damage_multiplier
			speed_multiplier += buff.speed_multiplier
			cooldown_multiplier += buff.cooldown_multiplier
			piercing += buff.piercing
			shots_added += buff.shots_added

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
	var rarety: Enums.BuffRarity = Enums.BuffRarity.COMMON
	var name: String
	var damage_multiplier: float
	var damage_interval_multiplier: float
	var damage_type: Enums.Element
	var attack_type = Enums.AttackType.CONE

	func _init(new_name: String, new_damage_multiplier: float, new_damage_interval_multiplier: float, new_damage_type: Enums.Element):
		name = new_name
		damage_multiplier = new_damage_multiplier
		damage_interval_multiplier = new_damage_interval_multiplier
		damage_type = new_damage_type

	func rarity(new_rarity: Enums.BuffRarity) -> ConeBuff:
		rarety = new_rarity
		return self

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if damage_interval_multiplier != 0:
			desc += "Decreases damage interval by " + str((damage_interval_multiplier)) + ".\n"

		return desc.strip_edges()

class ConeBuffCollection:
	var buffs: Array = []
	var damage_multiplier: float
	var damage_interval_multiplier: float
	var damage_type: Enums.Element
	var attack_type = Enums.AttackType.CONE

	func _init(new_buffs: Array, damageType: Enums.Element):
		buffs = new_buffs
		damage_type = damageType

		for buff in buffs:
			damage_multiplier += buff.damage_multiplier
			damage_interval_multiplier += buff.damage_interval_multiplier

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if damage_interval_multiplier != 0:
			desc += "Decreases damage interval by " + str((damage_interval_multiplier)) + ".\n"

		return desc.strip_edges()

class NovaBuff:
	var rarety: Enums.BuffRarity = Enums.BuffRarity.COMMON
	var name: String
	var damage_multiplier: float
	var radius_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Enums.Element
	var attack_type = Enums.AttackType.NOVA

	func _init(new_name: String, new_damage_multiplier: float, new_radius_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Enums.Element):
		name = new_name
		damage_multiplier = new_damage_multiplier
		radius_multiplier = new_radius_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type

	func rarity(new_rarity: Enums.BuffRarity) -> NovaBuff:
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

class NovaBuffCollection:
	var buffs: Array = []
	var damage_multiplier: float
	var radius_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Enums.Element
	var attack_type = Enums.AttackType.NOVA

	func _init(new_buffs: Array, damageType: Enums.Element):
		buffs = new_buffs
		damage_type = damageType

		for buff in buffs:
			damage_multiplier += buff.damage_multiplier
			radius_multiplier += buff.radius_multiplier
			cooldown_multiplier += buff.cooldown_multiplier

	func get_description() -> String:
		var desc = ""

		if damage_multiplier != 0:
			desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if radius_multiplier != 0:
			desc += "Increases radius by " + str((radius_multiplier)) + ".\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier)) + ".\n"

		return desc.strip_edges()
