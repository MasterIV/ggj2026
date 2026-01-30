extends Camera2D

@export var target: Node2D

func _ready():
	if not target:
		target = get_tree().get_first_node_in_group("player")

func _process(delta):
	if target:
		global_position = target.global_position
