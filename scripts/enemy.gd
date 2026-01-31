class_name Enemy
extends CharacterBody2D

const ENEMY_SCENE: PackedScene = preload("res://scenes/enemy.tscn")

enum Movement_pattern {
	STRAIGHT
}

@export var animated_sprite: AnimatedSprite2D

var health: float = 100
var speed: float
var movement_pattern: Movement_pattern
var player: CharacterBody2D
var current_direction: String = "down"
var damage_type: Enums.Element = Enums.Element.AQUA

static func spawn(position: Vector2, player: CharacterBody2D, speed := 100.0, health := 100, movement_pattern := Movement_pattern.STRAIGHT) -> Enemy:
	var new_enemy: Enemy = ENEMY_SCENE.instantiate()
	new_enemy.position = position
	new_enemy.player = player
	new_enemy.speed = speed
	new_enemy.movement_pattern = movement_pattern
	return new_enemy

func _physics_process(delta: float) -> void:
	match movement_pattern:
		Movement_pattern.STRAIGHT:
			move_straight(delta)
	move_and_slide()

func move_straight(delta: float) -> void:
	var direction: Vector2 = player.position - position
	direction = direction.normalized()
	velocity = direction * speed
	update_sprite_direction(direction)

func take_damage(amount: float, element: Enums.Element) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	queue_free()

func update_sprite_direction(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			current_direction = "right"
		else:
			current_direction = "left"
	else:
		if direction.y > 0:
			current_direction = "down"
		else:
			current_direction = "up"

func _process(delta: float) -> void:
	animated_sprite.play(get_animation_name(current_direction, damage_type))
	pass

func get_animation_name(current_direction: String, element: Enums.Element):
	return Enums.element_to_string(element) + "_" + current_direction
