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
				if left_buff == null:
					panel_instance.name_label.text = "No more buffs available"
					panel_instance.description_label.text = "You have unlocked all buffs for this element."
					panel_instance.pressed.connect(_on_no_upgrade)
				else:
					panel_instance.name_label.text = left_buff.name
					panel_instance.description_label.text = left_buff.get_description()
					panel_instance.rarity_label.text = left_buff.get_rarity_description()
					panel_instance.pressed.connect(_on_upgrade_left)
					panel_instance.set_element(left_buff.damage_type)
			1:
				if center_buff == null:
					panel_instance.name_label.text = "No more buffs available"
					panel_instance.description_label.text = "You have unlocked all buffs for this element."
					panel_instance.pressed.connect(_on_no_upgrade)
				else:
					panel_instance.name_label.text = center_buff.name
					panel_instance.description_label.text = center_buff.get_description()
					panel_instance.rarity_label.text = center_buff.get_rarity_description()
					panel_instance.pressed.connect(_on_upgrade_center)
					panel_instance.set_element(center_buff.damage_type)
			2:
				if right_buff == null:
					panel_instance.name_label.text = "No more buffs available"
					panel_instance.description_label.text = "You have unlocked all buffs for this element."
					panel_instance.pressed.connect(_on_no_upgrade)
				else:
					panel_instance.name_label.text = right_buff.name
					panel_instance.description_label.text = right_buff.get_description()
					panel_instance.rarity_label.text = right_buff.get_rarity_description()
					panel_instance.pressed.connect(_on_upgrade_right)
					panel_instance.set_element(right_buff.damage_type)

func _handle_buff(buff: Enums.Buff) -> void:
	player.add_buff.emit(
		buff.attack_type,
		buff
	)

func _on_no_upgrade() -> void:
	hide()
	get_tree().paused = false

func _on_upgrade_left() -> void:
	_handle_buff(left_buff)

	hide()
	get_tree().paused = false

func _on_upgrade_center() -> void:
	_handle_buff(center_buff)

	hide()
	get_tree().paused = false

func _on_upgrade_right() -> void:
	_handle_buff(right_buff)

	hide()
	get_tree().paused = false
