class_name Nova
extends Area2D

@export var start_scale: float = 0.2
@export var end_scale: float = 3.0
@export var growth_time: float = 1.0
@export var dissolve_time: float = 0.3
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var spawn_sound: AudioStream
@export var effect_sound: AudioStream

signal nova_finished

var elapsed_time: float = 0.0
var is_growing: bool = true

func _ready():
	scale = Vector2(start_scale, start_scale)

	if collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()

	if spawn_sound:
		play_sound(spawn_sound)

	if effect_sound:
		play_sound(effect_sound)

func _process(delta):
	elapsed_time += delta

	if is_growing:
		if elapsed_time >= growth_time:
			is_growing = false
			elapsed_time = 0.0
		else:
			var progress: float = elapsed_time / growth_time
			var current_scale = lerp(start_scale, end_scale, progress)
			scale = Vector2(current_scale, current_scale)
	else:
		if elapsed_time >= dissolve_time:
			nova_finished.emit()
			queue_free()
		else:
			var fade_progress: float = elapsed_time / dissolve_time
			modulate.a = 1.0 - fade_progress

func play_sound(sound: AudioStream):
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = sound
	audio_player.finished.connect(audio_player.queue_free)
	get_tree().root.add_child(audio_player)
	audio_player.play()
