extends Control

var nature_xp: int = 0
var water_xp: int = 0
var fire_xp: int = 0

@onready var nature_bar = $"2rows/3col_1/NatureXP"
@onready var water_bar = $"2rows/3col_1/WaterXP"
@onready var fire_bar = $"2rows/3col_1/FireXP"

func _ready() -> void:
	set_water_xp(0)
	set_fire_xp(0)
	set_nature_xp(0)

func add_water_xp(number: int) -> void:
	set_water_xp(water_xp + number)

func set_water_xp(number: int) -> void:
	water_xp = number
	update_bars()

func add_fire_xp(number: int) -> void:
	set_fire_xp(fire_xp + number)

func set_fire_xp(number: int) -> void:
	fire_xp = number
	update_bars()

func add_nature_xp(number: int) -> void:
	set_nature_xp(nature_xp + number)

func set_nature_xp(number: int) -> void:
	nature_xp = number
	update_bars()

func update_bars() -> void:
	nature_bar.value = nature_xp
	water_bar.value = water_xp
	fire_bar.value = fire_xp
