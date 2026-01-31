class_name Projectile
extends Area2D

@export var speed: float = 600.0
@export var lifetime: float = 2.0
@export var lifetime_timer: Timer
@export var damage: float
@export var spawn_sound: AudioStream
@export var hit_sound: AudioStream

var direction: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.start()

	if spawn_sound:
		play_sound(spawn_sound)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("obstacle"):
		print("Obstacle found")
		on_hit()
		on_destroy()
	elif body.is_in_group("enemy"):
		print("Enemy found")
		on_hit()
		on_destroy()

func _on_lifetime_timeout():
	on_destroy()

func on_hit():
	if hit_sound:
		play_sound(hit_sound)

func set_direction(dir: Vector2):
	direction = dir.normalized()

func on_destroy():
	queue_free()

func play_sound(sound: AudioStream):
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = sound
	audio_player.finished.connect(audio_player.queue_free)
	get_tree().root.add_child(audio_player)
	audio_player.play()
