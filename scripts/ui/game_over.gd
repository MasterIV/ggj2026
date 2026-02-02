extends Node2D

@export var label_last_wave_result: Label
@export var label_best_wave_result: Label

func _ready() -> void:
	label_last_wave_result.text = str(Global.global_state.get_last_result())
	label_best_wave_result.text = str(Global.global_state.get_best_result())


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
