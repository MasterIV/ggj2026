extends Node

class LevelEndData:

	var result: String
	var enemies_defeated: int
	var bosses_defeated: int
	var final_boss_defeated: bool

	func _init(_result: String, _enemies_defeated: int, _bosses_defeated: int, _final_boss_defeated: bool) -> void:
		result = _result
		enemies_defeated = _enemies_defeated
		bosses_defeated = _bosses_defeated
		final_boss_defeated = _final_boss_defeated

class GlobalState:

	var level_end_data: LevelEndData

	func set_player_id(player_id: String) -> void:
		SaveManager.load_data()
		SaveManager.set_player_id(player_id)

	func get_player_id() -> String:
		SaveManager.load_data()
		return SaveManager.get_player_id()

	func get_best_result():
		SaveManager.load_data()
		return SaveManager.get_best_score()

	func get_last_result():
		SaveManager.load_data()
		return SaveManager.get_last_score()

	func post_result(wave_count: int):
		SaveManager.load_data()
		SaveManager.set_score(wave_count)

	func set_level_end_data(result: String, enemies_defeated: int, bosses_defeated: int, final_boss_defeated: bool) -> void:
		level_end_data = LevelEndData.new(result, enemies_defeated, bosses_defeated, final_boss_defeated)


var global_state: GlobalState = GlobalState.new()
