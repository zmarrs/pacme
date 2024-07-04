extends Node
class_name PelletsManager

var total_pellets_count
var pellets_eaten = 0
var all_ghosts_whole: bool = true

@onready var ui = $"../UI"
@onready var chomp_sound_player = $"../SoundPlayers/ChompSoundPlayer"
@onready var power_pellet_sound_player = $"../SoundPlayers/PowerPelletSoundPlayer"
@onready var intermission_sound_player = $"../SoundPlayers/IntermissionSoundPlayer"
@onready var player = $"../Player"
@onready var points_manager = $"../PointsManager"
@onready var game_manager = TheGameManager
@onready var level_end_timer = $"../LevelEndTimer"
@onready var level = $".."
@export var ghost_array: Array[Ghost]

func _ready():
		var pellets = self.get_children() as Array[Pellet]
		total_pellets_count = pellets.size()
		for pellet in pellets:
			pellet.pellet_eaten.connect(on_pellet_eaten)

func _process(delta):
	all_ghosts_whole = true
	
	for ghost in ghost_array:
		if ghost.current_state == ghost.GhostState.RUN_AWAY:
			all_ghosts_whole = false
			
	if all_ghosts_whole:		
		power_pellet_sound_player.stop()
			
func on_pellet_eaten(allow_eating_ghosts: bool):
	if!chomp_sound_player.playing:
		chomp_sound_player.play()
	
	pellets_eaten += 1
	
	if allow_eating_ghosts:
		power_pellet_sound_player.play()
		for ghost in ghost_array:
			if ghost.current_state != ghost.GhostState.STARTING_AT_HOME:
				ghost.run_away_from_pacman()
	
	if  pellets_eaten == total_pellets_count:
		player.set_collision_layer_value(1, 0)		
		player.set_physics_process(false) 
		for ghost in ghost_array:
			ghost.hide()
		power_pellet_sound_player.stop()
		ui.level_won()
		intermission_sound_player.stop()
		intermission_sound_player.play()
		level_end_timer.stop()
		level_end_timer.wait_time = 6
		level_end_timer.start()

func _on_level_end_timer_timeout():
	var points = points_manager.get_points()
	game_manager.add_level_points(points)
	level.queue_free()
