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

func get_projectile_wall_position(center_pos: Vector2, shoot_direction: Vector2, index: int, total_count: int, spacing: float) -> Vector2:
	var perpendicular: Vector2 = Vector2(-shoot_direction.y, shoot_direction.x)
	var total_width: float = (total_count - 1) * spacing
	var start_offset: float = -total_width / 2.0
	var offset: float = start_offset + (index * spacing)
	return center_pos + (perpendicular * offset)

func get_direction_rotation(direction: Vector2) -> float:
	return direction.angle()


func element_to_string(element: Enums.Element):
	return {
		Enums.Element.AQUA: "aqua",
		Enums.Element.FIRE: "fire",
		Enums.Element.NATURE: "nature"
	}[element]

func string_to_element(element: String):
	return {
		"aqua": Enums.Element.AQUA,
		"fire": Enums.Element.FIRE,
		"nature": Enums.Element.NATURE
	}[element]
