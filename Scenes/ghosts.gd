extends Node

@onready var player = $"../Player" as Player

func _ready():
	player.player_dying.connect(hide_ghosts)
	player.player_died.connect(reset_ghosts)
		
func reset_ghosts(lives):
	var ghosts = get_children() as Array[Ghost]
	if lives == 0:
		for ghost in ghosts:
			ghost.show()			
			ghost.at_home_timer.stop()
			ghost.run_away_timer.stop()
			ghost.update_chasing_target_position_timer.stop()
			ghost.scatter_timer.stop()			
			ghost.current_at_home_index = 0
			ghost.scatter_timer.wait_time = 9000			
			ghost.scatter()
	else:
		for ghost in ghosts:
			ghost.is_blinking = false
			ghost.show()
			ghost.setup()


func hide_ghosts():
	var ghosts = get_children() as Array[Ghost]
	for ghost in ghosts:			
		ghost.set_collision_layer_value(1, false)
		ghost.set_collision_mask_value(1, false)
		ghost.hide()
