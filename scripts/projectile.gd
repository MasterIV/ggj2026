class_name Projectile
extends Area2D

@export var speed: float = 600.0
@export var lifetime: float = 2.0
@export var lifetime_timer: Timer
@export var damage: float
@export var spawn_sound: AudioStreamPlayer2D
@export var hit_sound: AudioStreamPlayer2D

var direction: Vector2 = Vector2.ZERO
var damage_type: Enums.Element = Enums.Element.NONE

func _ready():
	body_entered.connect(_on_body_entered)

	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.start()

	if spawn_sound:
		spawn_sound.play()

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("obstacle"):
		print("Obstacle found")
		on_hit()
		on_destroy()
	elif body.is_in_group("enemy"):
		print("Enemy found")

		if body.has_method("take_damage"):
			(body as Enemy).take_damage(damage, Enums.Element.AQUA) # TODO: Change element as needed
		else:
			print("Dealing %s damage to %s" % [damage, body.name])

		on_hit()
		on_destroy()

func _on_lifetime_timeout():
	on_destroy()

func on_hit():
	if hit_sound:
		hit_sound.play()

func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()

func on_destroy():
	queue_free()
