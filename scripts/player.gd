class_name Player
extends CharacterBody2D

@export var base_health: float = 1000
@export var speed: float = 300
@export var dash_speed: float = 800
@export var dash_duration: float = 0.2

@export var aqua_cooldown_ring: CooldownRing
@export var fire_cooldown_ring: CooldownRing
@export var nature_cooldown_ring: CooldownRing

# Ice Lance
@export var projectile_scene: PackedScene

# Seed Bomb
@export var nature_seed_bomb_scene: PackedScene

# Waterwall
@export var waterwall_projectile_scene: PackedScene

# Fire Cone
@export var cone_scene: PackedScene
@export var cone_distance: float = 60.0

# Nature Cone
@export var nature_cone_scene: PackedScene
@export var nature_cone_shot: PackedScene

# Fire Nova
@export var nova_scene: PackedScene

@export var animated_sprite: AnimatedSprite2D

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var active_cone: Area2D = null
var active_nova: Area2D = null
var current_direction: String = "down"
var current_projectile_spawn_cooldown: float = 0
var current_waterwall_spawn_cooldown: float = 0
var current_seed_bomb_spawn_cooldown: float = 0
var current_nova_spawn_cooldown: float = 0
var current_health: float

var is_last_wave = false
var current_wave: int

var audio_loop_manager: AudioLoopManager

var killed_enemies: Array[Enemy] = []

var ranking_integration: RankingIntegration

@export var mask_switch_cooldown: float = 0.3  # Minimum time between switches
var mask_switch_timer: float = 0.0

var buffs: Dictionary = {
	Enums.AttackType.PROJECTILE: [],
	Enums.AttackType.CONE: [],
	Enums.AttackType.NOVA: [],
	Enums.AttackType.ARTILLERY: [],
}

func _on_add_buff(attack_type: Enums.AttackType, buff: Enums.Buff) -> void:

	ranking_integration.on_powerup_collected(buff.name)

	if buff is Enums.HealBuff:
		print("Heal player for amount: ", buff.heal_amount)
		take_damage(-buff.heal_amount, Enums.Element.NONE)
		return

	buffs[attack_type].append(buff)

func get_buffs_by_type_and_element(attack_type: Enums.AttackType, element: Enums.Element) -> Array:
	var result: Array = []
	for buff in buffs[attack_type]:
		if buff.damage_type == element:
			result.append(buff)
	return result

signal last_wave_spawned()
signal enemy_killed(enemy: Enemy)
signal player_took_damage(damage: float, health_current: float, health_max: float)
signal player_died(killed_enemies: Array[Enemy])
signal add_buff(attack_type: Enums.AttackType, buff: Enums.Buff)

func _ready() -> void:
	audio_loop_manager = get_tree().get_first_node_in_group("audio_loop_manager")
	enemy_killed.connect(_on_enemy_killed)
	add_buff.connect(_on_add_buff)
	last_wave_spawned.connect(_on_last_wave_spawned)
	current_health = base_health

	var wave_counter: Node = get_tree().get_first_node_in_group("wave_counter")
	wave_counter.wave_spawned.connect(_on_wave_spawned)

	set_mask(Enums.Element.AQUA)

	ranking_integration = get_tree().get_first_node_in_group("ranking_integration")

func _on_last_wave_spawned():
	is_last_wave = true

var enemies_killed: int = 0
var bossed_killed: int = 0

func _on_enemy_killed(enemy: Enemy):

	if enemy.boss:
		bossed_killed += 1
		if enemy.is_final_boss:
			ranking_integration.on_boss_killed("final_boss")
		else:
			ranking_integration.on_boss_killed(str(enemy.damage_type) + "_" + str(enemy.health))
	else:
		enemies_killed += 1

	killed_enemies.append(enemy)

	#var remaining_enemies = get_tree().get_nodes_in_group("enemy")
	if is_last_wave && enemy.is_final_boss:
		#if remaining_enemies.size() == 0:
		win()


func _physics_process(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction * dash_speed
	else:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		#if Input.is_action_just_pressed("dash") and direction.length() > 0:
		#	is_dashing = true
		#	dash_timer = dash_duration
		#	dash_direction = direction.normalized()

		velocity = direction * speed

		if direction.length() > 0:
			update_sprite_direction(direction)

	move_and_slide()

func update_sprite_direction(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			current_direction = "right"
		else:
			current_direction = "left"
	else:
		if direction.y > 0:
			current_direction = "down"
		else:
			current_direction = "up"

var current_mask: int = 0
var available_masks = [Enums.Element.AQUA, Enums.Element.FIRE, Enums.Element.NATURE]

func get_active_mask():
	return available_masks[current_mask]

func check_input():
	if Input.is_action_pressed("secondary_attack"):
		trigger_secondaydary_attack(get_process_delta_time())

	if Input.is_action_just_pressed("mask_switch") || mask_switch_timer <= 0 && Input.is_action_just_pressed("mask_next"):
		switch_mask(1)

	if mask_switch_timer <= 0 && Input.is_action_just_pressed("mask_previous"):
		switch_mask(-1)

func switch_mask(direction: int):
	stop_primary_attack()

	var new_index = (current_mask + direction) % available_masks.size()
	_on_set_mask(new_index)

signal mask_changed(new_mask: Enums.Element)

func _on_set_mask(index: int):
	current_mask = index

	audio_loop_manager.mask_changed.emit(get_active_mask())

	mask_switch_timer = mask_switch_cooldown

	aqua_cooldown_ring.hide()
	fire_cooldown_ring.hide()
	nature_cooldown_ring.hide()

	match get_active_mask():
		Enums.Element.AQUA:
			aqua_cooldown_ring.show()
		Enums.Element.FIRE:
			fire_cooldown_ring.show()
		Enums.Element.NATURE:
			nature_cooldown_ring.show()

	mask_changed.emit(get_active_mask())


func set_mask(mask_type: Enums.Element):
	var index = available_masks.find(mask_type)
	_on_set_mask(index)


func _process(delta: float) -> void:
	check_input()
	update_nova_position()
	update_cone_position()
	trigger_primary_attack(delta)

	if current_waterwall_spawn_cooldown > 0:
		current_waterwall_spawn_cooldown -= delta

	if current_seed_bomb_spawn_cooldown > 0:
		current_seed_bomb_spawn_cooldown -= delta

	if current_nova_spawn_cooldown > 0:
		current_nova_spawn_cooldown -= delta

	if mask_switch_timer > 0:
		mask_switch_timer -= delta

	animated_sprite.play(get_animation_name(current_direction, get_active_mask()))

func shoot_projectile(delta: float, projectile_prefab: PackedScene) -> void:
	if not projectile_prefab:
		return

	if current_projectile_spawn_cooldown > 0:
		current_projectile_spawn_cooldown -= delta
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var shoot_direction: Vector2 = (mouse_pos - global_position).normalized()

	var config_projectile: Projectile = projectile_prefab.instantiate() as Projectile
	var number_shots: int = config_projectile.number_of_projectiles + config_projectile.get_shots_added_modifier()
	var shot_type: Enums.ProjectileShotType = config_projectile.shot_type
	var spacing: float = config_projectile.spacing
	config_projectile.queue_free()

	if shot_type == Enums.ProjectileShotType.ARC:
		shoot_direction = shoot_direction.rotated(deg_to_rad(spacing * (number_shots - 1) / (float)(number_shots)))
		for i in range(number_shots):
			shoot_direction = shoot_direction.rotated(deg_to_rad(spacing * i))
			var rotated_direction: Vector2 = shoot_direction
			var projectile: Projectile = projectile_prefab.instantiate() as Projectile
			projectile.damage_type = get_active_mask()
			projectile.global_position = global_position
			projectile.set_direction(rotated_direction)
			projectile.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
			projectile.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
			projectile.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())
			get_parent().add_child(projectile)
			current_projectile_spawn_cooldown = projectile.cooldown * projectile.get_cooldown_modifier()
	elif shot_type == Enums.ProjectileShotType.LINE:
		for i in range(number_shots):
			var projectile: Projectile = projectile_prefab.instantiate() as Projectile
			projectile.damage_type = get_active_mask()
			projectile.rotation = Enums.get_direction_rotation(shoot_direction)
			projectile.set_direction(shoot_direction)
			projectile.global_position = Enums.get_projectile_wall_position(
				global_position,
				shoot_direction,
				i,
				number_shots,
				spacing
			)
			projectile.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
			projectile.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
			projectile.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())
			get_parent().add_child(projectile)

			current_projectile_spawn_cooldown = projectile.cooldown * projectile.get_cooldown_modifier()

func spawn_nature_roots(delta: float, projectile_prefab: PackedScene) -> void:
	if not projectile_prefab:
		return

	if current_projectile_spawn_cooldown > 0:
		current_projectile_spawn_cooldown -= delta
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var shoot_direction: Vector2 = (mouse_pos - global_position).normalized()

	var config_projectile: Projectile = projectile_prefab.instantiate() as Projectile
	var number_shots: int = config_projectile.number_of_projectiles + config_projectile.get_shots_added_modifier()
	var shot_type: Enums.ProjectileShotType = config_projectile.shot_type
	var spacing: float = config_projectile.spacing
	config_projectile.queue_free()

	if shot_type == Enums.ProjectileShotType.ARC:
		shoot_direction = shoot_direction.rotated(deg_to_rad(spacing * (number_shots - 1) / (float)(number_shots)))
		for i in range(number_shots):
			shoot_direction = shoot_direction.rotated(deg_to_rad(spacing * i))
			var rotated_direction: Vector2 = shoot_direction
			var projectile: Projectile = projectile_prefab.instantiate() as Projectile
			projectile.damage_type = get_active_mask()
			projectile.global_position = global_position
			projectile.set_direction(rotated_direction)
			projectile.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
			projectile.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
			projectile.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())
			get_parent().add_child(projectile)
			current_projectile_spawn_cooldown = projectile.cooldown * projectile.get_cooldown_modifier()
	elif shot_type == Enums.ProjectileShotType.LINE:
		for i in range(number_shots):
			var projectile: Projectile = projectile_prefab.instantiate() as Projectile
			projectile.damage_type = get_active_mask()
			projectile.rotation = Enums.get_direction_rotation(shoot_direction)
			projectile.set_direction(shoot_direction)
			projectile.global_position = Enums.get_projectile_wall_position(
				global_position,
				shoot_direction,
				i,
				number_shots,
				spacing
			)
			projectile.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
			projectile.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
			projectile.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())
			get_parent().add_child(projectile)

			current_projectile_spawn_cooldown = projectile.cooldown * projectile.get_cooldown_modifier()

func shoot_waterwall_projectile(_delta: float, projectile_prefab: PackedScene) -> void:
	if not projectile_prefab:
		return

	if current_waterwall_spawn_cooldown > 0:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var shoot_direction: Vector2 = (mouse_pos - global_position).normalized()

	var config_projectile: Projectile = projectile_prefab.instantiate() as Projectile
	var number_shots: int = config_projectile.number_of_projectiles + config_projectile.get_shots_added_modifier()
	var shot_type: Enums.ProjectileShotType = config_projectile.shot_type
	var spacing: float = config_projectile.spacing
	var cooldown = config_projectile.cooldown * config_projectile.get_cooldown_modifier()
	config_projectile.queue_free()

	if shot_type == Enums.ProjectileShotType.ARC:
		shoot_direction = shoot_direction.rotated(deg_to_rad(spacing * (number_shots - 1) / (float)(number_shots)))
		for i in range(number_shots):
			shoot_direction = shoot_direction.rotated(deg_to_rad(spacing * i))
			var rotated_direction: Vector2 = shoot_direction
			var projectile: Projectile = projectile_prefab.instantiate() as Projectile
			projectile.damage_type = get_active_mask()
			projectile.global_position = global_position
			projectile.set_direction(rotated_direction)
			projectile.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
			projectile.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
			projectile.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())
			get_parent().add_child(projectile)
	elif shot_type == Enums.ProjectileShotType.LINE:
		for i in range(number_shots):
			var projectile: Projectile = projectile_prefab.instantiate() as Projectile
			projectile.damage_type = get_active_mask()
			projectile.rotation = Enums.get_direction_rotation(shoot_direction)
			projectile.set_direction(shoot_direction)
			projectile.global_position = Enums.get_projectile_wall_position(
				global_position,
				shoot_direction,
				i,
				number_shots,
				spacing
			)
			projectile.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
			projectile.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
			projectile.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())
			get_parent().add_child(projectile)

	current_waterwall_spawn_cooldown = cooldown

	aqua_cooldown_ring.cooldown_time = current_waterwall_spawn_cooldown
	aqua_cooldown_ring.start_cooldown()



func shoot_seed_bomb_projectile(_delta: float) -> void:
	if not nature_seed_bomb_scene:
		return

	if current_seed_bomb_spawn_cooldown > 0:
		return

	var target_pos: Vector2 = get_global_mouse_position()

	var artillery: Artillery = nature_seed_bomb_scene.instantiate() as Artillery
	artillery.damage_type = get_active_mask()
	artillery.global_position = global_position
	artillery.set_target(global_position, target_pos)
	artillery.buffs[Enums.AttackType.PROJECTILE] = get_buffs_by_type_and_element(Enums.AttackType.PROJECTILE, get_active_mask())
	artillery.buffs[Enums.AttackType.NOVA] = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())
	artillery.buffs[Enums.AttackType.CONE] = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())

	get_parent().add_child(artillery)

	current_seed_bomb_spawn_cooldown = artillery.cooldown * artillery.get_cooldown_modifier()

	nature_cooldown_ring.cooldown_time = current_seed_bomb_spawn_cooldown
	nature_cooldown_ring.start_cooldown()


func spawn_nova() -> void:
	if not nova_scene || active_nova != null:
		return

	if current_nova_spawn_cooldown > 0:
		return

	active_nova = nova_scene.instantiate() as Nova
	active_nova.damage_type = get_active_mask()
	active_nova.nova_finished.connect(_on_nova_finished)
	active_nova.buffs = get_buffs_by_type_and_element(Enums.AttackType.NOVA, get_active_mask())

	get_parent().add_child(active_nova)
	update_nova_position()

	current_nova_spawn_cooldown = active_nova.cooldown * active_nova.get_cooldown_modifier()

	fire_cooldown_ring.cooldown_time = current_nova_spawn_cooldown
	fire_cooldown_ring.start_cooldown()


func _on_nova_finished():
	active_nova = null

func update_nova_position() -> void:
	if not active_nova:
		return

	active_nova.global_position = global_position

func spawn_cone() -> void:
	if not cone_scene || active_cone != null:
		return

	active_cone = cone_scene.instantiate() as Cone
	active_cone.damage_type = get_active_mask()
	active_cone.buffs = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())

	get_parent().add_child(active_cone)
	update_cone_position()

func spawn_nature_cone() -> void:
	if not nature_cone_scene || active_cone != null:
		return

	active_cone = nature_cone_scene.instantiate() as Cone
	active_cone.damage_type = get_active_mask()
	active_cone.buffs = get_buffs_by_type_and_element(Enums.AttackType.CONE, get_active_mask())

	get_parent().add_child(active_cone)
	update_cone_position()

func update_cone_position() -> void:
	if not active_cone:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = (mouse_pos - global_position).normalized()

	active_cone.global_position = global_position + direction * cone_distance
	active_cone.rotation = direction.angle()

func destroy_cone():
	if active_cone:
		active_cone.queue_free()
		active_cone = null

func get_animation_name(direction: String, _element: Enums.Element):
	return Enums.element_to_string(get_active_mask()) + "_" + direction

func trigger_primary_attack(delta):
	match get_active_mask():
		Enums.Element.AQUA:
			shoot_projectile(delta, projectile_scene)
		Enums.Element.FIRE:
			spawn_cone()
		Enums.Element.NATURE:
			spawn_nature_roots(delta, nature_cone_shot)
			#spawn_nature_cone()
			pass

func trigger_secondaydary_attack(delta):
	match get_active_mask():
		Enums.Element.AQUA:
			shoot_waterwall_projectile(delta, waterwall_projectile_scene)
		Enums.Element.FIRE:
			spawn_nova()
		Enums.Element.NATURE:
			shoot_seed_bomb_projectile(delta)

func stop_primary_attack():
	match get_active_mask():
		Enums.Element.FIRE:
			destroy_cone()
		Enums.Element.NATURE:
			destroy_cone()

func take_damage(damage: float, _element: Enums.Element):
	current_health -= damage
	player_took_damage.emit(damage, current_health, base_health)

	var text = Floating_Number.spawn(position)
	get_parent().add_child(text)
	text.set_text(str(roundi(damage)), Color.GREEN)

	if (current_health <= 0):
		player_died.emit(killed_enemies)
		die()

func win():
	send_end_game_ranking("victory", true)
	get_tree().change_scene_to_file("res://scenes/ui/win.tscn")

func _on_wave_spawned(current: int, _max: int):
	current_wave = current

func die():
	send_end_game_ranking("defeat", false)
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")

func send_end_game_ranking(result: String, final_boss_defeated: bool):
	Global.global_state.post_result(current_wave)
	Global.global_state.set_level_end_data(result, enemies_killed, bossed_killed, final_boss_defeated)

	ranking_integration.end_game(result, enemies_killed, bossed_killed, buffs[Enums.AttackType.PROJECTILE].size(), buffs[Enums.AttackType.CONE].size(), buffs[Enums.AttackType.NOVA].size(), buffs[Enums.AttackType.ARTILLERY].size(), final_boss_defeated)
