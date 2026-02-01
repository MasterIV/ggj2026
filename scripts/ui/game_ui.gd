extends Control

var xp: float = 0.0
var xp_till_next: float = 100.0
var xp_progression_multiplier: float = 2.5
var player: Player

@onready var xp_bar = $"2rows/3col_1/XP"
@onready var hp_bar = $"2rows/3col_2/HP"
@onready var level_up_ui = $"LevelUpUiContainer"

func _ready() -> void:
	set_xp(0.0)
	update_health_bar(100.0)
	player = get_tree().get_first_node_in_group("player")
	player.enemy_killed.connect(_on_enemy_killed)
	player.player_took_damage.connect(_on_player_health_change)
	level_up_ui.hide()

func _on_enemy_killed(enemy: Enemy) -> void:
	add_xp(int(enemy.health))

func _on_player_health_change(damage: float, health_current: float, health_max: float) -> void:
	update_health_bar(health_current / health_max * 100.0)

func update_health_bar(percentage: float) -> void:
	hp_bar.value = percentage

func add_xp(number: float) -> void:
	set_xp(xp + number)

func set_xp(number: float) -> void:
	xp = number
	update_bar()

func update_bar() -> void:
	if xp >= xp_till_next:
		level_up()
	xp_bar.value = xp / xp_till_next * 100.0

func level_up() -> void:
	var xp_overhang = xp - xp_till_next
	xp = xp_overhang
	xp_till_next = xp_till_next * xp_progression_multiplier

	get_tree().paused = true
	level_up_ui.show()

func _on_upgrade_left() -> void:
	var attack_type = Enums.get_random_attack_type()
	var buff = Enums.get_random_buff(attack_type)

	player.add_buff.emit(
		attack_type,
		buff
	)

	level_up_ui.hide()
	get_tree().paused = false


func _on_upgrade_center() -> void:
	var attack_type = Enums.get_random_attack_type()
	var buff = Enums.get_random_buff(attack_type)

	player.add_buff.emit(
		attack_type,
		buff
	)

	level_up_ui.hide()
	get_tree().paused = false

func _on_upgrade_right() -> void:
	var attack_type = Enums.get_random_attack_type()
	var buff = Enums.get_random_buff(attack_type)

	player.add_buff.emit(
		attack_type,
		buff
	)

	level_up_ui.hide()
	get_tree().paused = false
