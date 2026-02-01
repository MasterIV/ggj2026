class_name LevelUpUiContainer
extends HBoxContainer

@export var upgrade_panel: PackedScene

var left_buff
var center_buff
var right_buff
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func setup():
	for child in get_children():
		child.queue_free()

	left_buff = Enums.get_random_buff_for_element(Enums.Element.AQUA)
	center_buff = Enums.get_random_buff_for_element(Enums.Element.FIRE)
	right_buff = Enums.get_random_buff_for_element(Enums.Element.NATURE)

	for i in range(3):
		var panel_instance = upgrade_panel.instantiate() as UpgradePanel
		add_child(panel_instance)
		match i:
			0:
				panel_instance.name_label.text = left_buff.name
				panel_instance.description_label.text = left_buff.get_description()
				panel_instance.pressed.connect(_on_upgrade_left)
			1:
				panel_instance.name_label.text = center_buff.name
				panel_instance.description_label.text = center_buff.get_description()
				panel_instance.pressed.connect(_on_upgrade_center)
			2:
				panel_instance.name_label.text = right_buff.name
				panel_instance.description_label.text = right_buff.get_description()
				panel_instance.pressed.connect(_on_upgrade_right)

func _on_upgrade_left() -> void:
	player.add_buff.emit(
		left_buff.attack_type,
		left_buff
	)

	hide()
	get_tree().paused = false

func _on_upgrade_center() -> void:
	player.add_buff.emit(
		center_buff.attack_type,
		center_buff
	)

	hide()
	get_tree().paused = false

func _on_upgrade_right() -> void:
	player.add_buff.emit(
		right_buff.attack_type,
		right_buff
	)

	hide()
	get_tree().paused = false
