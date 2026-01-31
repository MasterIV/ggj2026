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

class ConeBuff:
	var damage_multiplier: float
	var damage_interval_multiplier: float
	var damage_type: Element

class NovaBuff:
	var damage_multiplier: float
	var radius_multiplier: float
	var cooldown_multiplier: float
	var damage_type: Element
