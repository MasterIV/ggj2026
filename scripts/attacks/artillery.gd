class_name Artillery
extends Area2D

@export var speed: float = 600.0
@export var arc_height: float = 100.0
@export var flight_time: float = 1.5
@export var cooldown: float = 5
@export var secondary_effect_scene: PackedScene

var target_position: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var elapsed_time: float = 0.0
var damage_type: Enums.Element = Enums.Element.NONE
var pierced_enemies_left: int = 0

var buffs: Dictionary = {
	Enums.AttackType.PROJECTILE: [],
	Enums.AttackType.CONE: [],
	Enums.AttackType.NOVA: [],
}

func _physics_process(delta) -> void:
	if flight_time <= 0:
		return

	elapsed_time += delta

	if elapsed_time >= flight_time:
		_on_target_reached()
		return

	var progress: float = elapsed_time / flight_time
	var linear_pos: Vector2 = start_position.lerp(target_position, progress)
	var arc_offset: float = arc_height * sin(progress * PI)

	global_position = linear_pos + Vector2(0, -arc_offset)

	if progress < 1.0:
		var next_progress = min(progress + delta / flight_time, 1.0)
		var next_pos: Vector2 = start_position.lerp(target_position, next_progress)
		var next_arc: float = arc_height * sin(next_progress * PI)
		var next_global_pos: Vector2 = next_pos + Vector2(0, -next_arc)
		var direction: Vector2 = (next_global_pos - global_position).normalized()
		rotation = direction.angle()


func set_target(start_pos: Vector2, target_pos: Vector2):
	start_position = start_pos
	target_position = target_pos

	var distance: float = start_position.distance_to(target_position)
	var modified_speed: float = speed * get_speed_modifier()
	flight_time = distance / modified_speed

func _on_target_reached():
	_explode()

func _explode():
	if secondary_effect_scene:
		var effect_instance_config: Node = secondary_effect_scene.instantiate()
		var num_shots: int = 1

		if (effect_instance_config is Projectile):
			num_shots = effect_instance_config.number_of_projectiles + get_shots_added_modifier()

		effect_instance_config.queue_free()

		for i in range(num_shots):
			var random_angle: float = randf() * TAU
			var effect_instance: Node = secondary_effect_scene.instantiate()

			if (effect_instance is Projectile):
				effect_instance.set_direction(Vector2(cos(random_angle), sin(random_angle)))
				effect_instance.buffs = buffs
			elif (effect_instance is Nova):
				effect_instance.buffs = buffs[Enums.AttackType.NOVA]
			elif (effect_instance is Cone):
				effect_instance.set_rotation(random_angle)
				effect_instance.buffs = buffs[Enums.AttackType.CONE]

			effect_instance.global_position = global_position
			effect_instance.damage_type = damage_type
			get_parent().add_child(effect_instance)

	queue_free()

func get_speed_modifier() -> float:
	var modifier: float = 1.0
	for buff in buffs[Enums.AttackType.PROJECTILE]:
		modifier += (buff as Enums.ProjectileBuff).speed_multiplier
	return modifier

func get_shots_added_modifier() -> int:
	var modifier: int = 0
	for buff in buffs[Enums.AttackType.PROJECTILE]:
		modifier += (buff as Enums.ProjectileBuff).shots_added
	return modifier

func get_cooldown_modifier() -> float:
	var modifier: float = 1.0

	for buff in buffs[Enums.AttackType.PROJECTILE]:
		modifier -= (buff as Enums.ProjectileBuff).cooldown_multiplier

	return modifier
