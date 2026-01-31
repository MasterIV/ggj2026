extends Camera2D

@export var target: Node2D
@export var dead_zone_radius: float = 50.0
@export var follow_speed: float = 5.0

func _ready():
	position_smoothing_enabled = true
	if not target:
		target = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if target:
		var distance: float = global_position.distance_to(target.global_position)

		if distance > dead_zone_radius:
			global_position = global_position.lerp(target.global_position, follow_speed * delta)
