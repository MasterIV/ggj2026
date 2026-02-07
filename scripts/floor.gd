extends TileMapLayer

@export var player: Player
@export var chunk_size: int = 8
@export var view_distance: int = 2
@export var unload_distance: int = 4
@export var tile_size: float = 256.0
@export var world_size: Vector2i
@export var map_border_block: PackedScene

@export var obstacles_1x1: Array[PackedScene]
@export var obstacles_2x2: Array[PackedScene]
@export var decorations: Array[PackedScene]

@export var obstacles_1x1_per_chunk: int = 3
@export var obstacles_2x2_per_chunk: int = 1
@export var decorations_per_chunk: int = 5

var loaded_chunks: Dictionary = {}
var _chunk_update_timer: float = 0.0

func _ready():
	if not player:
		player = get_tree().get_first_node_in_group("player")
	update_chunks()

func _process(delta):
	_chunk_update_timer += delta
	if _chunk_update_timer >= 0.1:
		_chunk_update_timer = 0.0
		update_chunks()

func update_chunks():
	if not player:
		return

	var player_chunk = world_to_chunk(player.global_position)

	# Load nearby chunks
	for x in range(player_chunk.x - view_distance, player_chunk.x + view_distance + 1):
		for y in range(player_chunk.y - view_distance, player_chunk.y + view_distance + 1):
			var chunk_pos = Vector2i(x, y)
			if chunk_pos not in loaded_chunks:
				generate_chunk(chunk_pos)

	# Unload distant chunks
	var chunks_to_remove: Array[Vector2i] = []
	for chunk_pos in loaded_chunks:
		if abs(chunk_pos.x - player_chunk.x) > unload_distance or abs(chunk_pos.y - player_chunk.y) > unload_distance:
			chunks_to_remove.append(chunk_pos)

	for chunk_pos in chunks_to_remove:
		unload_chunk(chunk_pos)

func world_to_chunk(world_pos: Vector2) -> Vector2i:
	var tile_pos = local_to_map(world_pos)
	return Vector2i(
		int(floor(float(tile_pos.x) / chunk_size)),
		int(floor(float(tile_pos.y) / chunk_size))
	)

func generate_chunk(chunk_pos: Vector2i):
	var chunk_objects: Array[Node] = []

	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size

	var end_of_world_chunk = abs(chunk_pos.x) >= world_size.x or abs(chunk_pos.y) >= world_size.y

	# Generate floor tiles
	for x in range(chunk_size):
		for y in range(chunk_size):
			var tile_pos = Vector2i(start_x + x, start_y + y)
			var tile_id = randi() % 3
			if randf() < 0.01:
				tile_id = 3
			if randf() < 0.01:
				tile_id = 4
			set_cell(tile_pos, tile_id, Vector2i(0, 0))

	# Generate obstacles and decorations
	if end_of_world_chunk:
		generate_border(start_x, start_y, chunk_objects)
	else:
		generate_chunk_objects(start_x, start_y, chunk_objects)

	loaded_chunks[chunk_pos] = chunk_objects

func unload_chunk(chunk_pos: Vector2i):
	var chunk_data = loaded_chunks[chunk_pos]
	if chunk_data is Array:
		for obj in chunk_data:
			if is_instance_valid(obj):
				obj.queue_free()

	# Clear tiles
	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size
	for x in range(chunk_size):
		for y in range(chunk_size):
			erase_cell(Vector2i(start_x + x, start_y + y))

	loaded_chunks.erase(chunk_pos)

func generate_border(start_x: int, start_y: int, chunk_objects: Array[Node]) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			var new_block = map_border_block.instantiate()
			new_block.position = Vector2((start_x + x) * tile_size, (start_y + y) * tile_size)
			add_child(new_block)
			chunk_objects.append(new_block)

func generate_chunk_objects(start_x: int, start_y: int, chunk_objects: Array[Node]) -> void:
	var occupied: Array[int] = []

	# 1. Place 2x2 obstacles first (need room for all 4 tiles within chunk)
	if obstacles_2x2.size() > 0:
		var placed_2x2 = 0
		var attempts = 0
		while placed_2x2 < obstacles_2x2_per_chunk and attempts < 20:
			attempts += 1
			var x = randi() % (chunk_size - 1)
			var y = randi() % (chunk_size - 1)

			var indices = [
				x * chunk_size + y,
				(x + 1) * chunk_size + y,
				x * chunk_size + (y + 1),
				(x + 1) * chunk_size + (y + 1)
			]

			var blocked = false
			for idx in indices:
				if idx in occupied:
					blocked = true
					break

			if not blocked:
				for idx in indices:
					occupied.append(idx)
				var obj = obstacles_2x2.pick_random().instantiate()
				obj.position = Vector2((start_x + x + 0.5) * tile_size, (start_y + y + 0.5) * tile_size)
				obj.z_index = 100
				add_child(obj)
				chunk_objects.append(obj)
				placed_2x2 += 1

	# 2. Place 1x1 obstacles (avoid occupied tiles)
	if obstacles_1x1.size() > 0:
		var placed_1x1 = 0
		var attempts = 0
		while placed_1x1 < obstacles_1x1_per_chunk and attempts < 20:
			attempts += 1
			var x = randi() % chunk_size
			var y = randi() % chunk_size
			var idx = x * chunk_size + y

			if idx not in occupied:
				occupied.append(idx)
				var obj = obstacles_1x1.pick_random().instantiate()
				obj.position = Vector2((start_x + x) * tile_size, (start_y + y) * tile_size)
				obj.z_index = 100
				add_child(obj)
				chunk_objects.append(obj)
				placed_1x1 += 1

	# 3. Place decorations (avoid all occupied positions)
	if decorations.size() > 0:
		var placed_deco = 0
		var attempts = 0
		while placed_deco < decorations_per_chunk and attempts < 30:
			attempts += 1
			var x = randi() % chunk_size
			var y = randi() % chunk_size
			var idx = x * chunk_size + y

			if idx not in occupied:
				occupied.append(idx)
				var obj = decorations.pick_random().instantiate()
				obj.position = Vector2((start_x + x) * tile_size, (start_y + y) * tile_size)
				obj.z_index = 100
				add_child(obj)
				chunk_objects.append(obj)
				placed_deco += 1
