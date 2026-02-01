class_name DeathEffect

extends Node2D

const ENEMY_DEATH_SCENE: PackedScene = preload("res://scenes/effects/enemy_death.tscn")

var lifetime: float = 0

func _process(delta: float) -> void:
	lifetime = lifetime + delta
	if lifetime > 0.4:
		queue_free()

static func spawn(position: Vector2) -> DeathEffect:
	var new_effect: DeathEffect = ENEMY_DEATH_SCENE.instantiate() as DeathEffect
	new_effect.position = position
	return new_effect
