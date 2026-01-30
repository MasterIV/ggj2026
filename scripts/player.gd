extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	# Get input direction
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Set velocity
	velocity = direction * SPEED
	
	# Move the character
	move_and_slide()
