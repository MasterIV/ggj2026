class_name Player
extends CharacterBody2D

@export var base_health: float = 1000
@export var speed: float = 300
@export var dash_speed: float = 800
@export var dash_duration: float = 0.2

# Ice Lance
@export var projectile_scene: PackedScene

# Waterwall
@export var waterwall_projectile_scene: PackedScene

# Fire Cone
@export var cone_scene: PackedScene
@export var cone_distance: float = 60.0

# Nature Cone
@export var nature_cone_scene: PackedScene

# Fire Nova
@export var nova_scene: PackedScene

@export var animated_sprite: AnimatedSprite2D
@export var projectile_spawn_cooldown: float = 1.0
@export var waterwall_spawn_cooldown: float = 2.0

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var active_cone: Area2D = null
var active_nova: Area2D = null
var current_direction: String = "down"
var current_projectile_spawn_cooldown: float = 0
var current_waterwall_spawn_cooldown: float = 0

var audio_loop_manager: AudioLoopManager

func _ready() -> void:
	audio_loop_manager = get_tree().get_first_node_in_group("audio_loop_manager")


func _physics_process(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction * dash_speed
	else:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		if Input.is_action_just_pressed("dash") and direction.length() > 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = direction.normalized()

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

func _input(event):
	if Input.is_action_just_pressed("mask_switch"):
		stop_primary_attack()

		current_mask += 1
		if current_mask >= available_masks.size():
			current_mask = 0

		audio_loop_manager.mask_changed.emit(get_active_mask())

	if Input.is_action_pressed("secondary_attack"):
		trigger_secondaydary_attack(get_process_delta_time())

func _process(delta: float) -> void:
	update_nova_position()
	update_cone_position()
	trigger_primary_attack(delta)
	
	if current_waterwall_spawn_cooldown > 0:
		current_waterwall_spawn_cooldown -= delta
		return

	animated_sprite.play(get_animation_name(current_direction, get_active_mask()))

func shoot_projectile(delta: float) -> void:
	if not projectile_scene:
		return

	if current_projectile_spawn_cooldown > 0:
		current_projectile_spawn_cooldown -= delta
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var shoot_direction: Vector2 = (mouse_pos - global_position).normalized()

	var projectile: Projectile = projectile_scene.instantiate() as Projectile
	projectile.damage_type = get_active_mask()
	projectile.global_position = global_position
	projectile.set_direction(shoot_direction)

	get_parent().add_child(projectile)

	current_projectile_spawn_cooldown = projectile_spawn_cooldown

func shoot_waterwall_projectile(delta: float) -> void:
	if not waterwall_projectile_scene:
		return
		
	if current_waterwall_spawn_cooldown > 0:
		return

	var shoot_directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

	for shoot_direction in shoot_directions:
		var projectile: Projectile = waterwall_projectile_scene.instantiate() as Projectile
		projectile.damage_type = get_active_mask()
		projectile.global_position = global_position
		projectile.is_piercing = true
		projectile.set_direction(shoot_direction)

		get_parent().add_child(projectile)

	current_waterwall_spawn_cooldown = waterwall_spawn_cooldown

func spawn_nova() -> void:
	if not nova_scene || active_nova != null:
		return

	active_nova = nova_scene.instantiate() as Nova
	active_nova.damage_type = get_active_mask()
	active_nova.nova_finished.connect(_on_nova_finished)
	get_parent().add_child(active_nova)
	update_nova_position()

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
	get_parent().add_child(active_cone)
	update_cone_position()

func spawn_nature_cone() -> void:
	if not nature_cone_scene || active_cone != null:
		return

	active_cone = nature_cone_scene.instantiate() as Cone
	active_cone.damage_type = get_active_mask()
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

func get_animation_name(direction: String, element: Enums.Element):
	return Enums.element_to_string(get_active_mask()) + "_" + direction

func trigger_primary_attack(delta):
	match get_active_mask():
		Enums.Element.AQUA:
			shoot_projectile(delta)
		Enums.Element.FIRE:
			spawn_cone()
		Enums.Element.NATURE:
			spawn_nature_cone()
			pass

func trigger_secondaydary_attack(delta):
	match get_active_mask():
		Enums.Element.AQUA:
			shoot_waterwall_projectile(delta)
		Enums.Element.FIRE:
			spawn_nova()
		Enums.Element.NATURE:
			pass

func stop_primary_attack():
	match get_active_mask():
		Enums.Element.FIRE:
			destroy_cone()
		Enums.Element.NATURE:
			destroy_cone()
