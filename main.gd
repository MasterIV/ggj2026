extends Node2D

var spawn_timer: float = 10000.0

func _process(delta: float) -> void:
	spawn_timer = spawn_timer + delta
	if spawn_timer > 10000.0:
		var random_angle: float = randf() * 360.0 
		var enemy_pos := Vector2(cos(deg_to_rad(random_angle))*1500.0, sin(deg_to_rad(random_angle))*1500.0)
		var enemy := Enemy.spawn(enemy_pos, $Player)
		add_child(enemy)
		spawn_timer = 0.0
