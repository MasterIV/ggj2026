class_name UpgradePanel
extends TextureButton

@export var name_label: Label
@export var description_label: Label
@export var rarity_label: Label

@export var fire_panel: Texture2D
@export var aqua_panel: Texture2D
@export var nature_panel: Texture2D
@export var hp_panel: Texture2D

func set_element(element_type: Enums.Element):
	match element_type:
		Enums.Element.AQUA:
			texture_normal = aqua_panel
		Enums.Element.FIRE:
			texture_normal = fire_panel
		Enums.Element.NATURE:
			texture_normal = nature_panel
		Enums.Element.NONE: # not good
			texture_normal = hp_panel
