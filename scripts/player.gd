class_name Player
extends CharacterBody2D

@export var speed: float = 300
@export var dash_speed: float = 800
@export var dash_duration: float = 0.2

@export var projectile_scene: PackedScene

@export var cone_scene: PackedScene
@export var cone_distance: float = 60.0

@export var nova_scene: PackedScene

@export var animated_sprite: AnimatedSprite2D

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var active_cone: Area2D = null
var active_nova: Area2D = null
var current_direction: String = "down"

func _physics_process(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction * dash_speed
	else:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		if Input.is_action_just_pressed("dash") and direction.length() > 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = direction.normalized()

		velocity = direction * speed

		if direction.length() > 0:
			update_sprite_direction(direction)

	move_and_slide()

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

	animated_sprite.play("idle_" + current_direction)

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot_projectile()

	if Input.is_action_pressed("nova"):
		spawn_nova()

	if Input.is_action_pressed("cone"):
		if not active_cone:
			spawn_cone()
	elif active_cone:
		destroy_cone()

func _process(delta: float) -> void:
	update_nova_position()
	update_cone_position()

func shoot_projectile() -> void:
	if not projectile_scene:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var shoot_direction: Vector2 = (mouse_pos - global_position).normalized()

	var projectile: Projectile = projectile_scene.instantiate() as Projectile
	projectile.global_position = global_position
	projectile.set_direction(shoot_direction)

	get_parent().add_child(projectile)

func spawn_nova() -> void:
	if not nova_scene || active_nova != null:
		return

	active_nova = nova_scene.instantiate()
	active_nova.nova_finished.connect(_on_nova_finished)
	get_parent().add_child(active_nova)
	update_nova_position()

func _on_nova_finished():
	active_nova = null

func update_nova_position() -> void:
	if not active_nova:
		return

	active_nova.global_position = global_position

func spawn_cone() -> void:
	if not cone_scene:
		return

	active_cone = cone_scene.instantiate()
	get_parent().add_child(active_cone)
	update_cone_position()

func update_cone_position() -> void:
	if not active_cone:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = (mouse_pos - global_position).normalized()

	active_cone.global_position = global_position + direction * cone_distance

	active_cone.rotation = direction.angle()

func destroy_cone():
	if active_cone:
		active_cone.queue_free()
		active_cone = null
