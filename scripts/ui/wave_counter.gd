class_name WaveCounter
extends HBoxContainer

signal wave_spawned(current: int, max: int)

func _ready() -> void:
	wave_spawned.connect(_on_wave_spawned)
	
func _on_wave_spawned(current: int, max: int):
	$LabelCurrentWave.text = str(current)
	$LabelMaxWave.text = str(max)
