extends Node

class GlobalState:

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


var global_state: GlobalState = GlobalState.new()
