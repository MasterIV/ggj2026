extends Node2D

var spawn_distance: float = 2500.0
var spawn_timer: float = 0.0
var quit_dialog: ConfirmationDialog

var current_wave = 0
var waves = []

func _ready() -> void:
	init_quit_game_dialog()
	
	var file = FileAccess.open("data/waves.json", FileAccess.READ)
	waves = JSON.parse_string(file.get_as_text())

func _process(delta: float) -> void:
	spawn_timer = spawn_timer + delta
	if current_wave < len(waves) && spawn_timer > waves[current_wave].delay:
		spawn_wave(waves[current_wave])
		current_wave += 1
		
func spawn_wave(wave):
	for n in wave.enemies:
		var random_angle: float = deg_to_rad(randf() * 360.0)
		var enemy_pos := Vector2(cos(random_angle)*spawn_distance, sin(random_angle)*spawn_distance)
		var enemy := Enemy.spawn($Player.position + enemy_pos, $Player)
		add_child(enemy)

func _input(event):
	if event.is_action_pressed("exit_game"):
		quit_dialog.popup_centered()
		get_viewport().set_input_as_handled()

func init_quit_game_dialog():
	quit_dialog = ConfirmationDialog.new()
	quit_dialog.dialog_text = "Are you sure you want to quit?"
	quit_dialog.title = "Quit Game"
	quit_dialog.confirmed.connect(_on_quit_confirmed)
	add_child(quit_dialog)

func _on_quit_confirmed():
	get_tree().quit()
