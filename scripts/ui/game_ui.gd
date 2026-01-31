extends Control

var xp: int = 0

@onready var xp_bar = $"2rows/3col_1/XP"

func _ready() -> void:
	set_xp(0)

func add_xp(number: int) -> void:
	set_xp(xp + number)

func set_xp(number: int) -> void:
	xp = number
	update_bar()

func update_bar() -> void:
	xp_bar.value = xp
