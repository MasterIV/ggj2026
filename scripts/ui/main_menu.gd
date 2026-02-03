extends Node2D

@export var web_incompatible: Array[Node]

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")

func _ready() -> void:
	var effect = DeathEffect.spawn(Vector2(-100.0, -100.0))
	add_child(effect)

	if OS.has_feature("web"):
		for item in web_incompatible:
			item.hide()

func _process(_delta):
	if OS.has_feature("web"):
		if Input.is_action_just_pressed("toggle_fullscreen"):
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
