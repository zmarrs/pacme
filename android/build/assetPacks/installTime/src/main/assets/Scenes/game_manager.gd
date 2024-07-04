extends Node
class_name GameManager

var total_score = 0
var player_name
var current_level = 1
var level_1 = preload("res://Scenes/level_1.tscn")
var lives: int = 3
var high_scores:HighScores
var count_10000: int = 0
var extra_lives_earned: int = 0

func _ready():
	high_scores = HighScores.load_or_create()

func start_game():
	get_tree().root.remove_child(get_tree().root.get_child(0))
	var level_instance = level_1.instantiate() 
	get_tree().root.add_child(level_instance)

func add_level_points(points):
	current_level += 1
	total_score = points
	load_level(current_level)

func add_death_points(points):
	total_score += points

func load_level(level):
	var level_path = ""
	match level:
		2:
			level_path = preload("res://Scenes/level_2.tscn")
		3:
			level_path = preload("res://Scenes/level_3.tscn")
		4:
			level_path = preload("res://Scenes/level_4.tscn")
		5:
			level_path = preload("res://Scenes/level_5.tscn")
		6:
			level_path = preload("res://Scenes/level_1.tscn")
		7:
			level_path = preload("res://Scenes/level_2.tscn")
		8:			
			level_path = preload("res://Scenes/level_3.tscn")
		9:			
			level_path = preload("res://Scenes/level_4.tscn")
		10:			
			level_path = preload("res://Scenes/level_5.tscn")
		11:			
			level_path = preload("res://Scenes/high_scores.tscn")
		12:			
			level_path = preload("res://Scenes/main_menu.tscn")
			
	var level_instance = level_path.instantiate() 
	
	get_tree().root.add_child(level_instance)

func get_points():
	return total_score
	
func get_lives():
	return lives
	
func set_lives(new_lives):
	lives = new_lives
	
func get_current_level():
	return current_level
