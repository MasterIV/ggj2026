extends Area2D

@export var speed: float = 600.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.ZERO

func _ready():
	# Destroy after lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += direction * speed * delta

func set_direction(dir: Vector2):
	direction = dir.normalized()
