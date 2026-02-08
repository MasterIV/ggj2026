extends TextureRect

@export var aqua_mask: Texture2D
@export var fire_mask: Texture2D
@export var nature_mask: Texture2D

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.mask_changed.connect(_on_mask_changed)

func _on_mask_changed(new_mask_type: Enums.Element) -> void:
	match new_mask_type:
		Enums.Element.AQUA:
			texture = aqua_mask
		Enums.Element.FIRE:
			texture = fire_mask
		Enums.Element.NATURE:
			texture = nature_mask
		Enums.Element.NONE:
			texture = null
