class_name AudioLoopManager
extends Node

@export var standard_loop: AudioStreamPlayer
@export var aqua_loop: AudioStreamPlayer
@export var fire_loop: AudioStreamPlayer
@export var nature_loop: AudioStreamPlayer

signal mask_changed(mask_type: Enums.Element)

func _ready() -> void:
	standard_loop.play()
	aqua_loop.play()
	fire_loop.play()
	nature_loop.play()
	
	mask_changed.connect(_on_mask_changed)
	
	_on_mask_changed(Enums.Element.AQUA)

func _on_mask_changed(mask_type: Enums.Element):
	fire_loop.stop()
	aqua_loop.stop()
	nature_loop.stop()

	match mask_type:
		Enums.Element.AQUA:
			aqua_loop.play(standard_loop.get_playback_position())
		Enums.Element.FIRE:
			fire_loop.play(standard_loop.get_playback_position())
		Enums.Element.NATURE:
			nature_loop.play(standard_loop.get_playback_position())
