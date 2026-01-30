extends Area2D

@export var speed: float = 600.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	
	await get_tree().create_timer(lifetime).timeout
	on_destroy()

func _physics_process(delta):
	position += direction * speed * delta

func set_direction(dir: Vector2):
	direction = dir.normalized()

func _on_body_entered(body):
	if body.is_in_group("obstacle"):
		on_destroy()
	
func on_destroy():
	queue_free()
