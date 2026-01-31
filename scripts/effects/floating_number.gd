class_name Floating_Number
extends Node2D

const FLOATING_NUMBER_SCENE: PackedScene = preload("res://scenes/effects/floating_number.tscn")

@onready var label: Label = $Label

static func spawn(position: Vector2) -> Floating_Number:
	var new_text = FLOATING_NUMBER_SCENE.instantiate()
	new_text.position = position
	return new_text

func set_text(text: String, text_color: Color) -> void:
	label.text = text
	label.add_theme_color_override("font_color", text_color)
	#theme.font_color = text_color

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(randf_range(-100,100), -100), 0.7).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.4).set_delay(0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(0.3)
	tween.finished.connect(queue_free)
