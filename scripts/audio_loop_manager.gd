class_name AudioLoopManager
extends Node

@export var standard_loop: AudioStreamPlayer2D
@export var aqua_loop: AudioStreamPlayer2D
@export var fire_loop: AudioStreamPlayer2D
@export var nature_loop: AudioStreamPlayer2D

signal mask_changed(mask_type: Enums.Element)

func _ready() -> void:
	mask_changed.connect(_on_mask_changed)

func _on_mask_changed(mask_type: Enums.Element):
	aqua_loop.volume_db = 0.0 if mask_type == Enums.Element.AQUA else -80.0
	fire_loop.volume_db = 0.0 if mask_type == Enums.Element.FIRE else -80.0
	nature_loop.volume_db = 0.0 if mask_type == Enums.Element.NATURE else -80.0
	
	print("Mask changed to: ", mask_type)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mask_aqua"):
		mask_changed.emit(Enums.Element.AQUA)
	if event.is_action_pressed("mask_fire"):
		mask_changed.emit(Enums.Element.FIRE)
	if event.is_action_pressed("mask_nature"):
		mask_changed.emit(Enums.Element.NATURE)
