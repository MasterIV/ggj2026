extends Node

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
	var speed_multiplier: float
	var damage_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Element
	
	func _init(new_speed_multiplier: float, new_damage_multiplier: float, new_cooldown_multiplier: float, new_damage_type: Element):
		speed_multiplier = new_speed_multiplier
		damage_multiplier = new_damage_multiplier
		cooldown_multiplier = new_cooldown_multiplier
		damage_type = new_damage_type
	
class ConeBuff:
	var damage_multiplier: float
	var damage_interval_multiplier: float
	var damage_type: Element

class NovaBuff:
	var damage_multiplier: float
	var radius_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Element
