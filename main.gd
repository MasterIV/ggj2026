extends Node2D

var spawn_timer: float = 10000.0
var quit_dialog: ConfirmationDialog

func _ready() -> void:
	init_quit_game_dialog()

func _process(delta: float) -> void:
	spawn_timer = spawn_timer + delta
	if spawn_timer > 10000.0:
		var random_angle: float = randf() * 360.0
		var enemy_pos := Vector2(cos(deg_to_rad(random_angle))*1500.0, sin(deg_to_rad(random_angle))*1500.0)
		var enemy := Enemy.spawn(enemy_pos, $Player)
		add_child(enemy)
		spawn_timer = 0.0

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
