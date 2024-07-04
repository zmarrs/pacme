extends Node

var level_1 = preload("res://Scenes/level_1.tscn")
var high_scores:HighScores

@onready var high_score_text = %HighScoreText
@onready var high_score_name_text = %HighScoreNameText
@onready var game_manager = TheGameManager
@onready var camera_2d = $Camera2D

func _ready():
	set_process_input(true)
	high_scores = HighScores.load_or_create()
	
	if high_scores.scores[0] == 0:
		high_scores.scores[0] = 50000
		high_scores.names[0] = "ZAM"
		high_scores.scores[1] = 40000
		high_scores.names[1] = "MLG"
		high_scores.scores[2] = 30000
		high_scores.names[2] = "KGP"
		high_scores.scores[3] = 20000
		high_scores.names[3] = "PMN"
		high_scores.scores[4] = 10000
		high_scores.names[4] = "BUG"
		high_scores.scores[5] = 9000
		high_scores.names[5] = "PAC"
		high_scores.scores[6] = 8000
		high_scores.names[6] = "BKY"
		high_scores.scores[7] = 5000
		high_scores.names[7] = "PKY"
		high_scores.scores[8] = 2500
		high_scores.names[8] = "IKY"
		high_scores.scores[9] = 1000
		high_scores.names[9] = "CLD"
		high_scores.save()
	
	high_score_text.text = str(high_scores.scores[0])
	high_score_name_text.text = high_scores.names[0]
	game_manager.total_score = 0
	game_manager.lives = 3
	game_manager.current_level = 1
		
	camera_2d.swipe_detected.connect(_on_swipe_detected)
	

func _process(delta):
	if Input.is_action_pressed("left"):
		start_game()
	elif Input.is_action_pressed("right"):
		start_game()
	elif Input.is_action_pressed("up"):
		start_game()
	elif Input.is_action_pressed("down"):
		start_game()
	elif Input.is_action_pressed("press"):  
		start_game()
	

func start_game():
	queue_free()
	var levelInstance = level_1.instantiate() 
	get_tree().root.add_child(levelInstance)

func _on_swipe_detected(direction: String):
	print("Swipe direction: " + direction)
	if direction == "down":
		Input.action_press("down")
	elif direction == "up":
		Input.action_press("up")
	elif direction == "right":
		Input.action_press("right")
	elif direction == "left":
		Input.action_press("left")
