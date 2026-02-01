extends Node

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

func get_random_element() -> Enums.Element:
	var elements: Array[Enums.Element] = [Element.AQUA, Element.FIRE, Element.NATURE]
	return elements[randi() % elements.size()]

func get_random_attack_type() -> Enums.AttackType:
	var attack_types: Array[Enums.AttackType] = [AttackType.PROJECTILE, AttackType.CONE, AttackType.NOVA]
	return attack_types[randi() % attack_types.size()]

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

func get_random_buff_for_attack_type(attack_type: AttackType):
	var buffs = get_all_buffs()
	var filtered_buffs = []
	for buff in buffs:
		match attack_type:
			AttackType.PROJECTILE:
				if buff is ProjectileBuff:
					filtered_buffs.append(buff)
			AttackType.CONE:
				if buff is ConeBuff:
					filtered_buffs.append(buff)
			AttackType.NOVA:
				if buff is NovaBuff:
					filtered_buffs.append(buff)
	return filtered_buffs[randi() % filtered_buffs.size()]

# TODO replace with buffs.json
func get_all_buffs():
	return [
		# PRIMARY
		# Ice Lance (Projectile)
		ProjectileBuff.new("Aqua Lance Boost", .2, .5, .2, Element.AQUA, 1),
		# Fire Blast (Cone)
		ConeBuff.new("Fire Blast Boost", .5, .2, Element.FIRE),
		# Roots (Cone)
		ProjectileBuff.new("Nature Roots Boost", .2, .5, .2, Element.NATURE),

		# SECONDARY
		# Aqua Wave (Projectile
		ProjectileBuff.new("Aqua Wave Boost", .2, .5, .2, Element.AQUA),
		# Fire Nova (Nova)
		NovaBuff.new("Fire Nova Boost", .5, .2, 0.2, Element.FIRE),
		# Nature Seed Bomb (Nova)
		NovaBuff.new("Nature Seed Bomb Boost", .8, .2, 0.2, Element.NATURE),
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

	func get_description() -> String:
		var desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if speed_multiplier != 0:
			desc += "Increases speed by " + str((speed_multiplier)) + ".\n"
		if cooldown_multiplier != 0:
			desc += "Decreases cooldown by " + str((cooldown_multiplier)) + ".\n"
		if piercing > 0:
			desc += "Grants piercing through " + str(piercing) + " enemies.\n"
		return desc.strip_edges()

class ConeBuff:
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

	func get_description() -> String:
		var desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
		if damage_interval_multiplier != 0:
			desc += "Decreases damage interval by " + str((damage_interval_multiplier)) + ".\n"
		return desc.strip_edges()

class NovaBuff:
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

	func get_description() -> String:
		var desc = "Increases damage by " + str((damage_multiplier)) + ".\n"
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
