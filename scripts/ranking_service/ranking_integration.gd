class_name RankingIntegration
extends Node

var health_check_cooldown: float = 5
var last_healthcheck: float = 0
var score: int = 0
var healthy: bool = false

signal global_best_loaded(waves: int)
signal local_best_loaded(waves: int)
signal health_changed(healthy: bool)

func _ready() -> void:
	# Connect to ranking service signals
	RankingService.score_submitted.connect(_on_score_submitted)
	RankingService.score_submission_failed.connect(_on_score_submission_failed)
	RankingService.leaderboard_loaded.connect(_on_leaderboard_loaded)
	RankingService.player_stats_loaded.connect(_on_player_stats_loaded)

	RankingService.health_checked.connect(_on_health)

func _process(delta: float) -> void:
	if last_healthcheck <= 0:
		RankingService.check_health()
		last_healthcheck = health_check_cooldown
	else:
		last_healthcheck -= delta

func _on_health(is_healthy: bool, details: Dictionary):
	if is_healthy != healthy: # no change
		print("Send health changed: " + str(is_healthy))
		health_changed.emit(is_healthy)

	healthy = is_healthy

	if healthy:
		print("API is up! DB: ", details.get("database"))
	else:
		print("API down: ", details.get("error"))


## Call this when starting a new game
func start_game() -> void:
	score = 0
	RankingService.start_run()


## Call this when the player scores points
func add_score(points: int, reason: String = "") -> void:
	score += points

	# Optionally track scoring events
	if reason:
		RankingService.add_event("score_" + reason)


func on_boss_killed(boss_name: String) -> void:
	RankingService.add_checkpoint(score, "boss_%s_defeated" % boss_name)
	RankingService.add_event("boss_%s_defeated" % boss_name)

## Call this at checkpoints (level complete, etc.)
func on_level_complete(level_number: int) -> void:
	RankingService.add_checkpoint(score, "level_%d_complete" % level_number)
	RankingService.add_event("level_%d_complete" % level_number)


## Call this when collecting power-ups or items
func on_powerup_collected(powerup_type: String) -> void:
	RankingService.add_event("powerup_" + powerup_type)


## Call this when the game ends
func end_game(result: String, enemies_defeated: int, bosses_defeated: int, upgrades_collected_projectile: int, upgrades_collected_cone: int, upgrades_collected_nova: int, upgrades_collected_artillery: int, final_boss_defeated: bool) -> void:
	# You can include any game-specific metadata
	var metadata := {
		"result": result,
		"enemies_defeated": enemies_defeated,
		"bosses_defeated": bosses_defeated,
		"final_boss_defeated": final_boss_defeated,
		"upgrades_collected": {
			"projectile": upgrades_collected_projectile,
			"cone": upgrades_collected_cone,
			"nova": upgrades_collected_nova,
			"artillery": upgrades_collected_artillery
		}
	}

	RankingService.submit_score(score, metadata)


## Show the leaderboard
func show_leaderboard() -> void:
	# Options: "all", "day", "week", "month"
	RankingService.get_leaderboard(100, 0, "all")


## Show player's own stats
func show_my_stats() -> void:
	RankingService.get_my_stats()


# === Signal Handlers ===

func _on_score_submitted(result: Dictionary) -> void:
	print("Score submitted! Your rank: #", result.get("rank", "?"))

	# Show success message to player
	# update_ui_with_rank(result.rank)

	# Check if any flags were raised (for debugging)
	var flags = result.get("flags", [])
	if flags.size() > 0:
		print("Note: Server flagged this submission: ", flags)


func _on_score_submission_failed(error: String) -> void:
	print("Failed to submit score: ", error)
	# Show error message or retry option to player


func _on_leaderboard_loaded(entries: Array) -> void:
	print("Leaderboard loaded with ", entries.size(), " entries")

	for entry in entries:
		print("#%d - Player %s: %d points" % [
			entry.get("rank", 0),
			entry.get("player_id", "???").substr(0, 8),
			entry.get("score", 0)
		])

	# Update your leaderboard UI

	if (entries.size() == 0):
		global_best_loaded.emit(0)
	else:
		global_best_loaded.emit(int(entries[0].get("score")))


func _on_player_stats_loaded(stats: Dictionary) -> void:
	print("Your stats:")
	print("  Best score: ", stats.get("best_score", 0))
	print("  Global rank: #", stats.get("global_rank", "?"))
	print("  Total games: ", stats.get("total_games", 0))

	local_best_loaded.emit(int(stats.get("best_score", 0)))
