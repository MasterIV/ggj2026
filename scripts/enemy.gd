class_name Enemy
extends CharacterBody2D

const ENEMY_SCENE: PackedScene = preload("res://scenes/enemy.tscn")

enum Movement_pattern {
	STRAIGHT
}

@export var animated_sprite: AnimatedSprite2D
@export var hurt_box: Area2D

var health: float = 100
var speed: float
var movement_pattern: Movement_pattern
var player: Player
var current_direction: String = "down"
var damage_type: Enums.Element = Enums.Element.AQUA
var boss: bool = false
var damage: float = 1
var multipliers: Dictionary = {
	"aqua": 1.0,
	"fire": 1.0,
	"nature": 1.0
}

@onready var enemy_sprite = $AnimatedSprite2D

static func spawn(position: Vector2, player: CharacterBody2D, speed, health, damage, boss, damage_type, multipliers, movement_pattern := Movement_pattern.STRAIGHT) -> Enemy:
	var new_enemy: Enemy = ENEMY_SCENE.instantiate() as Enemy
	new_enemy.position = position
	new_enemy.player = player
	new_enemy.speed = speed
	new_enemy.movement_pattern = movement_pattern
	new_enemy.boss = boss
	new_enemy.health = health
	new_enemy.damage = damage
	new_enemy.damage_type = Enums.string_to_element(damage_type);
	new_enemy.multipliers = multipliers

	return new_enemy

func _ready() -> void:
	hurt_box.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			(body as Player).take_damage(damage, damage_type)

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

func take_damage(amount: float, element: Enums.Element) -> bool:
	amount = amount * multipliers[Enums.element_to_string(element)]

	health -= amount
	var text = Floating_Number.spawn(position)
	get_parent().add_child(text)
	text.set_text(str(roundi(amount)), Color.RED)
	if health <= 0:
		die()
		return true
	return false

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
	var prefix: String = "boss_" if boss else ""
	return prefix + Enums.element_to_string(element) + "_" + current_direction
