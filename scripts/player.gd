extends CharacterBody2D
@export var speed: float = 300
@export var dash_speed: float = 800
@export var dash_duration: float = 0.2
@export var projectile_scene: PackedScene  # Drag projectile.tscn here

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO

@onready var sprite = $Sprite2D

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
		if direction.x > 0:
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.flip_h = true
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot_projectile()

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
