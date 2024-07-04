extends TileMap

class_name MazeTileMap

var empty_cells = []
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


@onready var game_manager = TheGameManager

func _ready():
	var cells = get_used_cells(0)
	
	for cell in cells:
		var data = get_cell_tile_data(0, cell)
		if data.get_custom_data("isEmpty"):
			empty_cells.push_front(cell)
	
	set_color_for_level()

func get_random_empty_cell_position():
	return to_global(map_to_local(empty_cells.pick_random()))

func change_tile_map_color(new_color: Color):
	self.modulate = new_color

func set_color_for_level():
	var level = game_manager.get_current_level()
	match level:
		1:
			change_tile_map_color(green)
		2: 
			change_tile_map_color(pale_blue)
		3:
			change_tile_map_color(yellow)
		4: 
			change_tile_map_color(pink)
		5:
			change_tile_map_color(red)
		6: 
			change_tile_map_color(orange)
		7:
			change_tile_map_color(teal)
		8: 
			change_tile_map_color(purple)
		9:
			change_tile_map_color(white)
		10:
			change_tile_map_color(dark_red)
