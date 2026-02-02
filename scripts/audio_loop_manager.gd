class_name AudioLoopManager
extends Node

@export var standard_loop: AudioStreamPlayer2D
@export var aqua_loop: AudioStreamPlayer2D
@export var fire_loop: AudioStreamPlayer2D
@export var nature_loop: AudioStreamPlayer2D

signal mask_changed(mask_type: Enums.Element)

func _ready() -> void:
	print("Start audio looper")
	standard_loop.play()
	aqua_loop.play()
	fire_loop.play()
	nature_loop.play()
	
	mask_changed.connect(_on_mask_changed)
	
	_on_mask_changed(Enums.Element.AQUA)

func _on_mask_changed(mask_type: Enums.Element):
	AudioServer.set_bus_volume_db(get_audio_bus_index("Aqua"), 0.0 if mask_type == Enums.Element.AQUA else -80.0)
	AudioServer.set_bus_volume_db(get_audio_bus_index("Fire"), 0.0 if mask_type == Enums.Element.FIRE else -80.0)
	AudioServer.set_bus_volume_db(get_audio_bus_index("Nature"), 0.0 if mask_type == Enums.Element.NATURE else -80.0)

func get_audio_bus_index(audio_bus_name: String):
	return AudioServer.get_bus_index(audio_bus_name)
