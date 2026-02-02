class_name Cone
extends Area2D

@export var damage: float = 10.0
@export var damage_interval: float = 0.5
@export var damage_timer: Timer
@export var spawn_sound: AudioStreamPlayer2D
@export var effect_sound: AudioStreamPlayer2D
@export var sprite: AnimatedSprite2D

var bodies_in_range: Array = []
var damage_type: Enums.Element = Enums.Element.NONE
var player: Player
var buffs: Array = []

func _ready():
	player = get_tree().get_first_node_in_group("player")

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	sprite.play("default")

	damage_timer.wait_time = damage_interval * get_interval_modifier()
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	damage_timer.start()

	if spawn_sound:
		spawn_sound.play()

	if effect_sound:
		effect_sound.play()

func _on_body_entered(body):
	if body.is_in_group("enemy") and body not in bodies_in_range:
		bodies_in_range.append(body)

func _on_body_exited(body):
	if body in bodies_in_range:
		bodies_in_range.erase(body)

func _on_damage_timer_timeout():
	for body in bodies_in_range:
		apply_damage(body)

func apply_damage(body):
	if body.has_method("take_damage"):
		if (body as Enemy).take_damage(damage * get_damage_modifier(), damage_type):
			player.enemy_killed.emit(body as Enemy)

func get_interval_modifier() -> float:
	var modifier: float = 1.0

	for buff in buffs:
		modifier -= (buff as Enums.ConeBuff).damage_interval_multiplier

	return modifier

func get_damage_modifier() -> float:
	var modifier: float = 1.0

	for buff in buffs:
		modifier += (buff as Enums.ConeBuff).damage_multiplier

	return modifier
