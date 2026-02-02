extends Node

class GlobalState:
	var last_wave_result: int
	var best_wave_result: int
	
	func post_result(wave_count: int):
		last_wave_result = wave_count
		if (last_wave_result > best_wave_result):
			best_wave_result = last_wave_result
	
	
var global_state: GlobalState = GlobalState.new()
