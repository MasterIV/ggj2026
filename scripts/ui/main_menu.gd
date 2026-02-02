extends Node2D


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")


func _ready() -> void:
	var effect = DeathEffect.spawn(Vector2(-100.0, -100.0))
	add_child(effect)
