extends PanelContainer

@export var debug_label: Label

func _process(_delta: float) -> void:
	var text = "Active Enemies: " + str(get_tree().get_nodes_in_group("enemy").size()) + "\n"
	text += "Obstacles: " + str(get_tree().get_nodes_in_group("obstacle").size()) + "\n"
	text += "Projectiles: " + str(get_tree().get_nodes_in_group("projectile").size()) + "\n"
	text += "FPS: " + str(Engine.get_frames_per_second()) + "\n"
	text += "Static Memory: " + str(Performance.get_monitor(Performance.MEMORY_STATIC)) + "\n"

	debug_label.text = text
