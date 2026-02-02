extends Camera2D

@export var target: Node2D

func _ready():
	position_smoothing_enabled = true
	if not target:
		target = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if target:
		global_position = target.global_position
