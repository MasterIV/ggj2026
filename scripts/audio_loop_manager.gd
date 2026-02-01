class_name AudioLoopManager
extends Node

@export var standard_loop: AudioStreamPlayer2D
@export var aqua_loop: AudioStreamPlayer2D
@export var fire_loop: AudioStreamPlayer2D
@export var nature_loop: AudioStreamPlayer2D

signal mask_changed(mask_type: Enums.Element)

func _ready() -> void:
	mask_changed.connect(_on_mask_changed)

	set_loop(standard_loop)
	set_loop(aqua_loop)
	set_loop(fire_loop)
	set_loop(nature_loop)

func set_loop(audio_player: AudioStreamPlayer2D):
	if audio_player.stream is AudioStreamWAV:
		audio_player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	elif audio_player.stream is AudioStreamOggVorbis:
		audio_player.stream.loop = true
	elif audio_player.stream is AudioStreamMP3:
		audio_player.stream.loop = true

func _on_mask_changed(mask_type: Enums.Element):
	if mask_type == Enums.Element.AQUA:
		# set aqua loop position to standard loop and play
		var current_position = standard_loop.get_playback_position()
		aqua_loop.play();
		fire_loop.stop()
		nature_loop.stop();
		aqua_loop.seek(current_position)
	elif mask_type == Enums.Element.FIRE:
		var current_position = standard_loop.get_playback_position()
		fire_loop.play();
		aqua_loop.stop()
		nature_loop.stop();
		fire_loop.seek(current_position)
	elif mask_type == Enums.Element.NATURE:
		var current_position = standard_loop.get_playback_position()
		nature_loop.play();
		aqua_loop.stop()
		fire_loop.stop()
		nature_loop.seek(current_position)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mask_aqua"):
		mask_changed.emit(Enums.Element.AQUA)
	if event.is_action_pressed("mask_fire"):
		mask_changed.emit(Enums.Element.FIRE)
	if event.is_action_pressed("mask_nature"):
		mask_changed.emit(Enums.Element.NATURE)
