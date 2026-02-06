class_name CooldownRing
extends TextureRect

@export var cooldown_time: float = 5.0
@export var cooldown_ring: TextureRect
@export var color: Color = Color.RED

var cooldown_timer: float = 0.0

func _ready():
	# make sure material is unique
	# otherwise all instances are modified
	if cooldown_ring.material:
		cooldown_ring.material = cooldown_ring.material.duplicate()

	set_color(color);

func start_cooldown():
	set_cooldown_time(cooldown_time)

func set_cooldown_time(new_cooldown: float):
	cooldown_timer = new_cooldown

func set_color(new_color: Color):
	cooldown_ring.material.set_shader_parameter("ready_color", new_color)

func _process(delta):
	if cooldown_timer > 0:
		cooldown_timer -= delta

		var progress: float = 1.0 - (cooldown_timer / cooldown_time)
		progress = clamp(progress, 0.0, 1.0)

		if cooldown_ring.material:
			cooldown_ring.material.set_shader_parameter("progress", progress)
