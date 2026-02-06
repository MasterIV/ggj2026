class_name AudioLoopManager
extends Node

@export var standard_loop: AudioStreamPlayer
@export var aqua_loop: AudioStreamPlayer
@export var fire_loop: AudioStreamPlayer
@export var nature_loop: AudioStreamPlayer

@export_group("Overlay Volumes")
@export var aqua_volume_db: float = -6.0
@export var fire_volume_db: float = -6.0
@export var nature_volume_db: float = -6.0

@export var crossfade_duration: float = 0.5

signal mask_changed(mask_type: Enums.Element)

const MUTED_VOLUME_DB: float = -80.0

func _ready() -> void:
	# Start all loops simultaneously for perfect sync
	standard_loop.play()
	aqua_loop.play()
	fire_loop.play()
	nature_loop.play()

	# Standard always audible, overlays start muted
	silence_all_overlays()

	mask_changed.connect(_on_mask_changed)
	_on_mask_changed(Enums.Element.AQUA)

func _on_mask_changed(mask_type: Enums.Element):
	var tween = create_tween().set_parallel(true)

	# Fade out all overlays
	tween.tween_method(
		func(vol): set_bus_volume_db("Aqua", vol),
		get_bus_volume_db("Aqua"),
		MUTED_VOLUME_DB,
		crossfade_duration
	)
	tween.tween_method(
		func(vol): set_bus_volume_db("Fire", vol),
		get_bus_volume_db("Fire"),
		MUTED_VOLUME_DB,
		crossfade_duration
	)
	tween.tween_method(
		func(vol): set_bus_volume_db("Nature", vol),
		get_bus_volume_db("Nature"),
		MUTED_VOLUME_DB,
		crossfade_duration
	)

	# Fade in the active overlay
	match mask_type:
		Enums.Element.AQUA:
			tween.tween_method(
				func(vol): set_bus_volume_db("Aqua", vol),
				MUTED_VOLUME_DB,
				aqua_volume_db,
				crossfade_duration
			)
		Enums.Element.FIRE:
			tween.tween_method(
				func(vol): set_bus_volume_db("Fire", vol),
				MUTED_VOLUME_DB,
				fire_volume_db,
				crossfade_duration
			)
		Enums.Element.NATURE:
			tween.tween_method(
				func(vol): set_bus_volume_db("Nature", vol),
				MUTED_VOLUME_DB,
				nature_volume_db,
				crossfade_duration
			)
		Enums.Element.NONE:
			# Just standard, all overlays muted
			pass

func get_bus_index(bus_name: String) -> int:
	return AudioServer.get_bus_index(bus_name)

func get_bus_volume_db(bus_name: String) -> float:
	var bus_index: int = get_bus_index(bus_name)
	if bus_index != -1:
		return AudioServer.get_bus_volume_db(bus_index)
	return MUTED_VOLUME_DB

func set_bus_volume_db(bus_name: String, volume_db: float) -> void:
	var bus_index: int = get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, volume_db)

func silence_all_overlays() -> void:
	set_bus_volume_db("Aqua", MUTED_VOLUME_DB)
	set_bus_volume_db("Fire", MUTED_VOLUME_DB)
	set_bus_volume_db("Nature", MUTED_VOLUME_DB)
