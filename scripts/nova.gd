class_name Nova
extends Area2D

@export var start_scale: float = 0.2
@export var end_scale: float = 3.0
@export var growth_time: float = 1.0
@export var dissolve_time: float = 0.3
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var spawn_sound: AudioStreamPlayer2D
@export var effect_sound: AudioStreamPlayer2D
@export var damage: float = 100

signal nova_finished

var elapsed_time: float = 0.0
var is_growing: bool = true
var damage_type: Enums.Element = Enums.Element.NONE
var player: Player
var buffs: Array = []

func _ready():
	player = get_tree().get_first_node_in_group("player")

	body_entered.connect(_on_body_entered)
	for body in get_overlapping_bodies():
		_on_body_entered(body)  # Manually trigger for existing overlaps

	scale = Vector2(start_scale, start_scale)

	if collision_shape.shape:
		collision_shape.shape = collision_shape.shape.duplicate()

	if spawn_sound:
		spawn_sound.play()

	if effect_sound:
		effect_sound.play()

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

			# Update collision shape size
			if collision_shape and collision_shape.shape is CircleShape2D:
				var base_radius = collision_shape.shape.radius / scale.x  # Get unscaled radius
				collision_shape.shape.radius = base_radius * current_scale
			else:
				print("Collision shape not found")
	else:
		if elapsed_time >= dissolve_time:
			nova_finished.emit()
			queue_free()
		else:
			var fade_progress: float = elapsed_time / dissolve_time
			modulate.a = 1.0 - fade_progress

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			if (body as Enemy).take_damage(damage * get_damage_multiplier(), damage_type):
				player.enemy_killed.emit(body as Enemy)

func get_damage_multiplier() -> float:
	var multiplier: float = 1.0

	for buff in buffs:
		multiplier += (buff as Enums.NovaBuff).damage_multiplier

	return multiplier
