extends Area2D


const OFF = preload("res://Assets/Bulb/off.png")

@onready var sprite_2d = $Sprite2D
@onready var tile_map = $"../TileMap"
@onready var game_manager = TheGameManager


var green = Color(0, 4, 0, 1)
var pale_blue = Color(3, 4, 5, 1)
var yellow = Color(5, 5, 0, 1)
var pink = Color(7, 4, 5, 1)
var red = Color(4, 0, 0, 1)
var orange = Color(7, 3, 0, 1)
var teal = Color(3, 7, 3, 1)
var purple = Color(3, 0, 3, 1)
var white = Color(7, 7, 7, 1)
var dark_red = Color(1, 0, 0, 1)
var black = Color(0, 0, 0, 1)

func _ready():
	if game_manager.get_current_level() < 2:
		queue_free()

func _on_outage_timer_timeout():
	sprite_2d.texture = OFF
	tile_map.change_tile_map_color(black)


func _on_body_entered(body):
	if body is Player and sprite_2d.texture == OFF:
		tile_map.set_color_for_level()
		queue_free()
