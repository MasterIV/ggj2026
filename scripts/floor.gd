extends TileMapLayer

@export var player: Player
@export var chunk_size: int = 8
@export var view_distance: int = 2

var loaded_chunks: Dictionary = {}

func _ready():
	if not player:
		player = get_tree().get_first_node_in_group("player")

	update_chunks()

func _process(_delta):
	update_chunks()

func update_chunks():
	if not player:
		return

	var player_chunk = world_to_chunk(player.global_position)

	for x in range(player_chunk.x - view_distance, player_chunk.x + view_distance + 1):
		for y in range(player_chunk.y - view_distance, player_chunk.y + view_distance + 1):
			var chunk_pos = Vector2i(x, y)
			if chunk_pos not in loaded_chunks:
				generate_chunk(chunk_pos)

func world_to_chunk(world_pos: Vector2) -> Vector2i:
	var tile_pos = local_to_map(world_pos)
	return Vector2i(
		int(floor(float(tile_pos.x) / chunk_size)),
		int(floor(float(tile_pos.y) / chunk_size))
	)

func generate_chunk(chunk_pos: Vector2i):
	loaded_chunks[chunk_pos] = true

	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size

	for x in range(chunk_size):
		for y in range(chunk_size):
			var tile_pos = Vector2i(start_x + x, start_y + y)
			set_cell(tile_pos, 0, Vector2i(0, 0))  # coords, source_id, atlas_coords
