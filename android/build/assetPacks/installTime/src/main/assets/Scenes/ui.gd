extends CanvasLayer

class_name UI

@onready var center_container = $MarginContainer/CenterContainer
@onready var life_count_label = %LifeCountLabel
@onready var game_score_label = %GameScoreLabel
@onready var game_label = %GameLabel
@onready var reset_timer = $ResetTimer
@onready var game_manager = TheGameManager
@onready var points_manager = $"../PointsManager"

func set_lives(lives):
	life_count_label.text = " %d UP " % lives 
	if lives == 0:
		game_lost()
		
func set_score(score):
	game_score_label.text = " SCORE: %d" % score
		
func game_lost():
	game_label.text = "GAME OVER"
	center_container.show()
	reset_timer.stop()
	reset_timer.wait_time = 6
	reset_timer.start()
	
func level_won():
	game_label.text = "LEVEL WON!"
	center_container.show()

func game_won():
	game_label.text = "VICTORY! ACME SALUTES YOU!"
	center_container.show()

func _on_reset_timer_timeout():
	var parent = get_parent()
	parent.queue_free()
	game_manager.add_death_points(points_manager.get_points())
	game_manager.load_level(11)
