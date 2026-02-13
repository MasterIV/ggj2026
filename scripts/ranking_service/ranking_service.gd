# RankingService.gd
# Autoload singleton for communicating with the ranking backend
# Add to Project > Project Settings > Autoload as "RankingService"

extends Node

## Configuration - Set these in your game
var api_base_url: String = "http://localhost:8000"
@export var game_id: String = "maskztec-survivors"

# get app version from godot project settings
var game_version: String = ProjectSettings.get_setting("application/config/version", "1.0.0")

## HMAC Secret - MUST match your server's secret
## For desktop: You can obfuscate this
## For browser: Accept this can be found - use additional server-side validation
const HMAC_SECRET: String = "097e047b8806161180460e173116eb18a274b4f7d0b774a582cfd9b8d30feeb4"

## Signals
signal score_submitted(result: Dictionary)
signal score_submission_failed(error: String)
signal leaderboard_loaded(entries: Array)
signal leaderboard_load_failed(error: String)
signal player_stats_loaded(stats: Dictionary)
signal health_checked(is_healthy: bool, details: Dictionary)

## Internal state
var player_id: String = ""
var session_id: String = ""
var current_run_id: String = ""
var current_run_start_time: int = 0
var current_checkpoints: Array[Dictionary] = []
var current_events: Array[String] = []

## HTTP request nodes
var _submit_request: HTTPRequest
var _leaderboard_request: HTTPRequest
var _player_stats_request: HTTPRequest
var _health_request: HTTPRequest

func _ready() -> void:
	_setup_http_requests()
	_load_or_create_player_id()
	_create_session_id()

	if OS.has_feature("editor"):
		api_base_url = "http://localhost:8000"
	else:
		api_base_url = "https://ranking.elbe.games"

func _setup_http_requests() -> void:
	_submit_request = HTTPRequest.new()
	_submit_request.request_completed.connect(_on_submit_completed)
	add_child(_submit_request)

	_leaderboard_request = HTTPRequest.new()
	_leaderboard_request.request_completed.connect(_on_leaderboard_completed)
	add_child(_leaderboard_request)

	_player_stats_request = HTTPRequest.new()
	_player_stats_request.request_completed.connect(_on_player_stats_completed)
	add_child(_player_stats_request)

	_health_request = HTTPRequest.new()
	_health_request.request_completed.connect(_on_health_completed)
	add_child(_health_request)

	check_health()

func check_health() -> void:
	var url := api_base_url + "/api/v1/health"
	var error := _health_request.request(url)
	if error != OK:
		health_checked.emit(false, {"error": "Request failed"})

func _load_or_create_player_id() -> void:
	player_id = Global.global_state.get_player_id()
	if player_id.length() >= 8:
		print("[RankingService] Loaded player ID: ", player_id.substr(0, 8), "...")
		return

	# Generate new player ID
	player_id = _generate_uuid()
	Global.global_state.set_player_id(player_id)

	print("[RankingService] Created new player ID: ", player_id.substr(0, 8), "...")

func _on_health_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		health_checked.emit(false, {"error": "Connection failed", "code": response_code})
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		health_checked.emit(false, {"error": "Invalid response"})
		return

	var is_healthy: bool = json.get("status") == "healthy"
	health_checked.emit(is_healthy, json)

func _create_session_id() -> void:
	session_id = _generate_uuid()
	print("[RankingService] Session ID: ", session_id.substr(0, 8), "...")


## Call this when a game run starts
func start_run() -> void:
	current_run_id = _generate_uuid()
	current_run_start_time = Time.get_ticks_msec()
	current_checkpoints.clear()
	current_events.clear()
	print("[RankingService] Started run: ", current_run_id.substr(0, 8), "...")


## Record a checkpoint during gameplay
## Call this at significant moments (level complete, boss defeated, etc.)
func add_checkpoint(current_score: int, event_name: String = "") -> void:
	var checkpoint := {
		"time_ms": Time.get_ticks_msec() - current_run_start_time,
		"score": current_score,
		"event": event_name if event_name else null
	}
	current_checkpoints.append(checkpoint)

	if event_name:
		current_events.append(event_name)


## Record a game event
## Use for tracking player actions for validation
func add_event(event_name: String) -> void:
	current_events.append(event_name)


## Submit the final score
## Call this when the game run ends
func submit_score(final_score: int, metadata: Dictionary = {}) -> void:
	if current_run_id.is_empty():
		push_error("[RankingService] Cannot submit score - no run started. Call start_run() first!")
		score_submission_failed.emit("No run started")
		return

	var duration_ms := Time.get_ticks_msec() - current_run_start_time
	var platform := _get_platform()

	# Create signature
	var signature := _create_signature(final_score, duration_ms)

	# Build submission payload
	var payload := {
		"game_id": game_id,
		"player_id": player_id,
		"session_id": session_id,
		"run_id": current_run_id,
		"score": final_score,
		"duration_ms": duration_ms,
		"game_version": game_version,
		"platform": platform,
		"checkpoints": current_checkpoints,
		"events": current_events,
		"metadata": metadata,
		"signature": signature
	}

	var json := JSON.stringify(payload)
	var headers := ["Content-Type: application/json"]
	var url := api_base_url + "/api/v1/scores"

	var error := _submit_request.request(url, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("[RankingService] Failed to send request: ", error)
		score_submission_failed.emit("Request failed")


## Fetch the leaderboard
func get_leaderboard(limit: int = 100, offset: int = 0, period: String = "all", platform_filter: String = "") -> void:
	var url := "%s/api/v1/leaderboard/%s?limit=%d&offset=%d&period=%s" % [
		api_base_url, game_id, limit, offset, period
	]

	if platform_filter:
		url += "&platform=" + platform_filter

	var error := _leaderboard_request.request(url)
	if error != OK:
		push_error("[RankingService] Failed to fetch leaderboard: ", error)
		leaderboard_load_failed.emit("Request failed")


## Fetch current player's stats
func get_my_stats() -> void:
	var url := "%s/api/v1/player/%s/%s" % [api_base_url, game_id, player_id]

	var error := _player_stats_request.request(url)
	if error != OK:
		push_error("[RankingService] Failed to fetch player stats: ", error)


## Get the current player ID (useful for displaying to user)
func get_player_id_short() -> String:
	return player_id.substr(0, 8) if player_id.length() >= 8 else player_id


# === Private Methods ===

func _generate_uuid() -> String:
	# Generate a UUID v4-like string
	var chars := "0123456789abcdef"
	var uuid := ""
	for i in range(32):
		if i == 8 or i == 12 or i == 16 or i == 20:
			uuid += "-"
		uuid += chars[randi() % 16]
	return uuid


func _get_platform() -> String:
	match OS.get_name():
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			return "desktop"
		"Android", "iOS":
			return "mobile"
		"Web":
			return "browser"
		_:
			return "desktop"


func _create_signature(score: int, duration_ms: int) -> String:
	# Create HMAC-SHA256 signature
	# Payload format must match server: game_id:player_id:run_id:score:duration_ms
	var payload := "%s:%s:%s:%d:%d" % [game_id, player_id, current_run_id, score, duration_ms]

	var ctx := HMACContext.new()
	ctx.start(HashingContext.HASH_SHA256, HMAC_SECRET.to_utf8_buffer())
	ctx.update(payload.to_utf8_buffer())
	var hmac := ctx.finish()

	# Convert to hex string
	var hex := ""
	for byte in hmac:
		hex += "%02x" % byte
	return hex


func _on_submit_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("[RankingService] Submit request failed with result: ", result)
		score_submission_failed.emit("Network error")
		return

	var json = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200:
		print("[RankingService] Score submitted! Rank: ", json.get("rank", "N/A"))
		score_submitted.emit(json)

		# Check for flags (potential issues detected by server)
		var flags = json.get("flags", [])
		if flags.size() > 0:
			print("[RankingService] Server flags: ", flags)
	else:
		var detail = json.get("detail", "Unknown error") if json else "Unknown error"
		push_error("[RankingService] Submit failed: ", detail)
		score_submission_failed.emit(detail)


func _on_leaderboard_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("[RankingService] Leaderboard request failed")
		leaderboard_load_failed.emit("Network error")
		return

	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var entries = json.get("entries", [])
		leaderboard_loaded.emit(entries)
	else:
		leaderboard_load_failed.emit("Server error: " + str(response_code))


func _on_player_stats_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		return

	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		player_stats_loaded.emit(json)
