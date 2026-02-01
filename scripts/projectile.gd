class_name Projectile
extends Area2D

@export var damage: float
@export var speed: float = 600.0
@export var lifetime: float = 2.0
@export var lifetime_timer: Timer
@export var cooldown: float = 1
@export var is_piercing: bool = false
@export var piercing_number: int = 0
@export var spawn_sound: AudioStreamPlayer2D
@export var hit_sound: AudioStreamPlayer2D
@export var number_of_projectiles: int = 1
@export var shot_type: Enums.ProjectileShotType = Enums.ProjectileShotType.ARC
@export var spacing: float

# triggered before primary attack dissolves
@export var secondary_effect_scene: PackedScene

var direction: Vector2 = Vector2.ZERO
var damage_type: Enums.Element = Enums.Element.NONE
var player: Player
var pierced_enemies_left: int = 0

# special case, needsa all buffs since it can trigger secondary effects
var buffs: Dictionary = {
	Enums.AttackType.PROJECTILE: [],
	Enums.AttackType.CONE: [],
	Enums.AttackType.NOVA: [],
}

func _ready():
	player = get_tree().get_first_node_in_group("player")

	body_entered.connect(_on_body_entered)

	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.start()

	pierced_enemies_left = piercing_number + get_piercing_modifier()

	if spawn_sound:
		spawn_sound.play()

func _physics_process(delta):
	var calculated_speed: float =  speed * get_speed_modifier()
	position += direction * calculated_speed * delta

func _on_body_entered(body):
	if body.is_in_group("obstacle") && !is_piercing:
		on_hit()
		on_destroy()
	elif body.is_in_group("enemy"):

		if body.has_method("take_damage"):
			if (body as Enemy).take_damage(damage * get_damage_modifier(), damage_type):
				player.enemy_killed.emit(body as Enemy)

		on_hit()

		if !is_piercing || pierced_enemies_left <= 0:
			on_destroy()
		else:
			pierced_enemies_left -= 1

func _on_lifetime_timeout():
	on_destroy()

func on_hit():
	if hit_sound:
		hit_sound.play()

func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()

func on_destroy():
	if secondary_effect_scene:
		for i in range(3):
			var random_angle = randf() * TAU
			var effect_instance = secondary_effect_scene.instantiate()

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

func get_piercing_modifier() -> int:
	var modifier: int = 0

	for buff in buffs[Enums.AttackType.PROJECTILE]:
		modifier += (buff as Enums.ProjectileBuff).piercing

	return modifier

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

func get_damage_modifier() -> float:
	var modifier: float = 1.0

	for buff in buffs[Enums.AttackType.PROJECTILE]:
		modifier += (buff as Enums.ProjectileBuff).damage_multiplier

	return modifier
