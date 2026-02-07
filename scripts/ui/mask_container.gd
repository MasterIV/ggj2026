extends TextureRect

@export var mask_type: Enums.Element
@export var default_mask: Texture2D
@export var active_mask: Texture2D

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.mask_changed.connect(_on_mask_changed)

func _on_mask_changed(new_mask_type: Enums.Element) -> void:
	if new_mask_type == mask_type:
		texture = active_mask
	else:
		texture = default_mask
