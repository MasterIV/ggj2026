extends CharacterBody2D
@export var speed: float = 300
@export var dash_speed: float = 800
@export var dash_duration: float = 0.2
@export var projectile_scene: PackedScene  # Drag projectile.tscn here
@export var cone_scene: PackedScene
@export var cone_distance: float = 60.0  # How far from player
@export var nova_scene: PackedScene
@export var animated_sprite: AnimatedSprite2D

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO
var active_cone = null
var active_nova = null
var current_direction = "down"

func _physics_process(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction * dash_speed
	else:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if Input.is_action_just_pressed("dash") and direction.length() > 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = direction.normalized()
		
		velocity = direction * speed
		
		# Flip sprite based on horizontal movement
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
		update_cone_position()
	elif active_cone:
		destroy_cone()

func shoot_projectile():
	if not projectile_scene:
		return
	
	# Get mouse position in world coordinates
	var mouse_pos = get_global_mouse_position()
	var shoot_direction = (mouse_pos - global_position).normalized()
	
	# Create and spawn projectile
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.set_direction(shoot_direction)
	
	# Add to scene tree (same level as player)
	get_parent().add_child(projectile)

func spawn_nova():
	if not nova_scene:
		return
	
	active_nova = nova_scene.instantiate()
	get_parent().add_child(active_nova)
	update_nova_position()

func update_nova_position():
	if not active_nova:
		return
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	active_nova.global_position = global_position
	
func spawn_cone():
	if not cone_scene:
		return
	
	active_cone = cone_scene.instantiate()
	get_parent().add_child(active_cone)
	update_cone_position()

func update_cone_position():
	if not active_cone:
		return
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	active_cone.global_position = global_position + direction * cone_distance
	
	active_cone.rotation = direction.angle()

func destroy_cone():
	if active_cone:
		active_cone.queue_free()
		active_cone = null
