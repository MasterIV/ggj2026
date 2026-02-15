extends Node2D

@export var label_last_wave_result: Label
@export var label_best_wave_result: Label
@export var label_global_best_wave_result: Label
@export var hide_if_offline: Array[Node]

func _ready() -> void:
	label_last_wave_result.text = str(Global.global_state.get_last_result())
	label_best_wave_result.text = str(Global.global_state.get_best_result())
	label_global_best_wave_result.text = "load ..."

	# access results from run
	var level_end_data: Global.LevelEndData = Global.global_state.level_end_data
	var waves_spawned: int = Global.global_state.get_last_result()
	var enemies_defeated: int = level_end_data.enemies_defeated
	var bosses_defeated: int = level_end_data.bosses_defeated

	var ranking_integration: RankingIntegration = get_tree().get_first_node_in_group("ranking_integration")

	ranking_integration.global_best_loaded.connect(_on_global_best_loaded)
	#ranking_integration.local_best_loaded.connect(_on_local_best_loaded)
	ranking_integration.health_changed.connect(_on_health_changed)

	ranking_integration.show_leaderboard()
	ranking_integration.show_my_stats()

	if !ranking_integration.healthy:
		for ui_element in hide_if_offline:
			ui_element.hide()

func _on_health_changed(new_health: bool):
	print("Health changed received: " + str(new_health))

	if new_health:
		for ui_element in hide_if_offline:
			ui_element.show()
	else:
		for ui_element in hide_if_offline:
			ui_element.hide()

func _on_global_best_loaded(waves: int):
	if waves < Global.global_state.get_best_result():
		waves = Global.global_state.get_best_result() # compensate for score post request is too slow

	label_global_best_wave_result.text = str(waves)

func _on_local_best_loaded(waves: int):
	label_best_wave_result.text = str(waves)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _process(_delta: float) -> void:
	if OS.has_feature("web"):
		if Input.is_action_just_pressed("toggle_fullscreen"):
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
