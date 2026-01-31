extends Node

@export var standard_loop: AudioStreamPlayer2D
@export var aqua_loop: AudioStreamPlayer2D
@export var fire_loop: AudioStreamPlayer2D
@export var nature_loop: AudioStreamPlayer2D

enum MaskType {
	NONE,
	AQUA,
	FIRE,
	NATURE
}

signal mask_changed(mask_type)

func _ready() -> void:
	mask_changed.connect(_on_mask_changed)

func _on_mask_changed(mask_type: MaskType):
	aqua_loop.volume_db = 0.0 if mask_type == MaskType.AQUA else -80.0
	fire_loop.volume_db = 0.0 if mask_type == MaskType.FIRE else -80.0
	nature_loop.volume_db = 0.0 if mask_type == MaskType.NATURE else -80.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mask_aqua"):
		mask_changed.emit(MaskType.AQUA)
	if event.is_action_pressed("mask_fire"):
		mask_changed.emit(MaskType.FIRE)
	if event.is_action_pressed("mask_nature"):
		mask_changed.emit(MaskType.NATURE)
