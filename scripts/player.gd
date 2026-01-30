extends CharacterBody2D

@export var speed: float = 300
@export var dash_speed: float = 800
@export var dash_duration: float = 0.2

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO

func _physics_process(delta):
	# Handle dash
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction * dash_speed
	else:
		# Get input direction
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		# Check for dash input
		if Input.is_action_just_pressed("dash") and direction.length() > 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = direction.normalized()
		
		# Set normal velocity
		velocity = direction * speed
	
	# Move the character
	move_and_slide()
