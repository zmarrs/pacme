extends Node

var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
			 	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letter_index = 0
var current_initial = 1
var player_top_score_index = 1
var input_enabled: bool = true

@onready var save_label = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/SaveLabel

@onready var score_entering_container = $CanvasLayer/ScoreEnteringContainer
@onready var score_list_container = $CanvasLayer/ScoreListContainer
var high_scores:HighScores
@onready var game_manager = TheGameManager
var visible: bool

@onready var initial_1 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/HBoxContainer/Initial_1
@onready var initial_2 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/HBoxContainer/Initial_2
@onready var initial_3 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/HBoxContainer/Initial_3
@onready var input_delay_timer = $InputDelayTimer



@onready var name_1 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer1/Name1
@onready var score_1 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer1/Score1
@onready var name_2 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer2/Name2
@onready var score_2 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer2/Score2
@onready var name_3 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer3/Name3
@onready var score_3 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer3/Score3
@onready var name_4 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer4/Name4
@onready var score_4 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer4/Score4
@onready var name_5 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer5/Name5
@onready var score_5 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer5/Score5
@onready var name_6 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer6/Name6
@onready var score_6 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer6/Score6
@onready var name_7 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer7/Name7
@onready var score_7 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer7/Score7
@onready var name_8 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer8/Name8
@onready var score_8 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer8/Score8
@onready var name_9 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer9/Name9
@onready var score_9 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer9/Score9
@onready var name_10 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer10/Name10
@onready var score_10 = $CanvasLayer/ScoreListContainer/CenterContainer/Panel/VBoxContainer/HBoxContainer10/Score10
@onready var restart_timer = $RestartTimer
@onready var camera_2d = $Camera2D
@onready var mobile_joystick = $MobileJoystick
@onready var upperscore_1 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/UpperHBoxContainer/upperscore_1
@onready var upperscore_2 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/UpperHBoxContainer/upperscore_2
@onready var upperscore_3 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/UpperHBoxContainer/upperscore_3
@onready var underscore_1 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/LowerHBoxContainer/underscore_1
@onready var underscore_2 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/LowerHBoxContainer/underscore_2
@onready var underscore_3 = $CanvasLayer/ScoreEnteringContainer/CenterContainer/Panel/LowerHBoxContainer/underscore_3


func _ready():
	high_scores = HighScores.load_or_create()
	player_top_score_index = high_scores.update_top_scores(game_manager.get_points())
	if player_top_score_index != -1:
		score_entering_container.show()
		score_list_container.hide()
	else:
		current_initial = 5
		populate_score_list()
		score_entering_container.hide()
		score_list_container.show()
		restart_timer.start()
		
	camera_2d.swipe_detected.connect(_on_swipe_detected)

func _process(delta):
	if input_enabled:			
		if mobile_joystick.joystick_active == true:
			input_delay_timer.wait_time = 0.44
		else:	
			input_delay_timer.wait_time = 0.22
			
		if Input.is_action_pressed("left"):
			go_back()
			input_enabled = false
			input_delay_timer.start()
		elif Input.is_action_pressed("right"):
			save_letter()
			input_enabled = false
			input_delay_timer.start()
		elif Input.is_action_pressed("up"):
			change_letter(-1)
			input_enabled = false
			input_delay_timer.start()
		elif Input.is_action_pressed("down"):
			change_letter(1)	
			input_enabled = false
			input_delay_timer.start()
	
func change_letter(index_change):	
	if letter_index == 0 && index_change == -1:
		letter_index = 25
	elif letter_index == 25 && index_change == 1:
		letter_index = 0
	else:
		letter_index += index_change
		
	if current_initial == 1:
		initial_1.text = letters[letter_index]
	elif current_initial == 2:
		initial_2.text = letters[letter_index]
	elif current_initial == 3:
		initial_3.text = letters[letter_index]
	
func go_back():
	if current_initial == 2:
		current_initial = 1
		initial_2.hide()
		upperscore_1.add_theme_color_override("font_color", Color(1, 1, 1))
		underscore_1.add_theme_color_override("font_color", Color(1, 1, 1))
		upperscore_2.add_theme_color_override("font_color", Color(0, 0, 0))
		underscore_2.add_theme_color_override("font_color", Color(0, 0, 0))
	elif current_initial == 3:		
		upperscore_2.add_theme_color_override("font_color", Color(1, 1, 1))
		underscore_2.add_theme_color_override("font_color", Color(1, 1, 1))
		upperscore_3.add_theme_color_override("font_color", Color(0, 0, 0))
		underscore_3.add_theme_color_override("font_color", Color(0, 0, 0))
		current_initial = 2		
		initial_3.hide()
	elif current_initial == 4:
		upperscore_3.add_theme_color_override("font_color", Color(1, 1, 1))
		underscore_3.add_theme_color_override("font_color", Color(1, 1, 1))
		current_initial = 3
		save_label.hide()
	

func save_letter():
	if current_initial == 1:
		upperscore_1.add_theme_color_override("font_color", Color(0, 0, 0))
		underscore_1.add_theme_color_override("font_color", Color(0, 0, 0))
		upperscore_2.add_theme_color_override("font_color", Color(1, 1, 1))
		underscore_2.add_theme_color_override("font_color", Color(1, 1, 1))
		current_initial = 2
		initial_2.show()
	elif current_initial == 2:
		upperscore_2.add_theme_color_override("font_color", Color(0, 0, 0))
		underscore_2.add_theme_color_override("font_color", Color(0, 0, 0))
		upperscore_3.add_theme_color_override("font_color", Color(1, 1, 1))
		underscore_3.add_theme_color_override("font_color", Color(1, 1, 1))
		current_initial = 3
		initial_3.show()
	elif current_initial == 3:
		upperscore_3.add_theme_color_override("font_color", Color(0, 0, 0))
		underscore_3.add_theme_color_override("font_color", Color(0, 0, 0))
		current_initial = 4
		save_label.show()
	elif current_initial == 4:
		current_initial = 5
		var name = "" + initial_1.text + initial_2.text + initial_3.text
		high_scores.insert_new_score(player_top_score_index, game_manager.get_points(), name)
		high_scores.save()
		populate_score_list()
		score_entering_container.hide()
		score_list_container.show()
		restart_timer.start()

func populate_score_list():
	name_1.text = high_scores.names[0]	
	score_1.text = str(high_scores.scores[0])
	name_2.text = high_scores.names[1]	
	score_2.text = str(high_scores.scores[1])
	name_3.text = high_scores.names[2]	
	score_3.text = str(high_scores.scores[2])
	name_4.text = high_scores.names[3]	
	score_4.text = str(high_scores.scores[3])
	name_5.text = high_scores.names[4]	
	score_5.text = str(high_scores.scores[4])
	name_6.text = high_scores.names[5]	
	score_6.text = str(high_scores.scores[5])
	name_7.text = high_scores.names[6]	
	score_7.text = str(high_scores.scores[6])	
	name_8.text = high_scores.names[7]	
	score_8.text = str(high_scores.scores[7])	
	name_9.text = high_scores.names[8]	
	score_9.text = str(high_scores.scores[8])	
	name_10.text = high_scores.names[9]	
	score_10.text = str(high_scores.scores[9])

func _on_restart_timer_timeout():
	queue_free()
	game_manager.load_level(12)

func _on_input_delay_timer_timeout():
	input_enabled = true

func _on_swipe_detected(direction: String):
	if direction == "down":
		Input.action_press("down")
	elif direction == "up":
		Input.action_press("up")
	elif direction == "right":
		Input.action_press("right")
	elif direction == "left":
		Input.action_press("left")
