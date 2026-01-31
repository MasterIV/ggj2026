class_name Enemy
extends CharacterBody2D

const ENEMY_SCENE: PackedScene = preload("res://scenes/enemy.tscn")

enum Movement_pattern {
	STRAIGHT
}

@export var animated_sprite: AnimatedSprite2D
@export var hurt_box: Area2D
@export var damage_timer: Timer

var health: float = 100
var damage_taken: float = 0.0
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
var deal_damage_cooldown: float = 1.0

var has_player_in_range: bool = false

@onready var enemy_sprite = $AnimatedSprite2D

static func spawn(position: Vector2, player: CharacterBody2D, speed, health, damage, deal_damage_cooldown, boss, damage_type, multipliers, movement_pattern := Movement_pattern.STRAIGHT) -> Enemy:
	var new_enemy: Enemy = ENEMY_SCENE.instantiate() as Enemy
	new_enemy.position = position
	new_enemy.player = player
	new_enemy.speed = speed
	new_enemy.movement_pattern = movement_pattern
	new_enemy.boss = boss
	new_enemy.health = health
	new_enemy.damage = damage
	new_enemy.deal_damage_cooldown = deal_damage_cooldown
	new_enemy.damage_type = Enums.string_to_element(damage_type);
	new_enemy.multipliers = multipliers

	return new_enemy

func _ready() -> void:
	hurt_box.body_entered.connect(_on_body_entered)
	hurt_box.body_exited.connect(_on_body_exited)

	damage_timer.timeout.connect(_on_damage_timer_timeout)
	damage_timer.wait_time = deal_damage_cooldown
	damage_timer.one_shot = false
	damage_timer.start()

func _on_damage_timer_timeout() -> void:
	if has_player_in_range:
		player.take_damage(damage, damage_type)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		has_player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		has_player_in_range = false

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

	damage_taken = damage_taken + amount
	var text = Floating_Number.spawn(position)
	get_parent().add_child(text)
	text.set_text(str(roundi(amount)), Color.RED)
	if damage_taken >= health:
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
