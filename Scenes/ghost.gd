extends Area2D

class_name Ghost

enum GhostState {
	SCATTER,
	CHASE,
	RUN_AWAY,
	EATEN,
	STARTING_AT_HOME,
}

signal direction_change(current_direction: String)

#variables
var current_scatter_index = 0
var direction = null
var current_state: GhostState
var current_at_home_index = 0
var is_blinking = false
var scatter_targets: Array = []
var home_targets: Array = []

#export variables
@export var at_home_wait_time = 0
@export var scatter_wait_time = 0
@export var eaten_speed = 240
@export var speed = 120
@export var movement_targets: Node 
@export var tile_map: MazeTileMap
@export var color: Color
@export var chasing_target: Node2D
@export var points_manager: PointsManager
@export var is_starting_at_home = false
@export var starting_position: Node2D
@export var ghost_eaten_sound_player: AudioStreamPlayer2D
@export var starting_texture: Texture2D
@onready var game_manager = TheGameManager

@export var red_scatter_target_paths: Array = [
	"../../MovementTargets/RedGhost/Scatter/Red1", 
	"../../MovementTargets/RedGhost/Scatter/Red2", 
	"../../MovementTargets/RedGhost/Scatter/Red3", 
	"../../MovementTargets/RedGhost/Scatter/Red4"
]
@export var red_home_target_paths: Array = [
	"../../MovementTargets/RedGhost/Home/Top",  
	"../../MovementTargets/RedGhost/Home/Bottom"
]
@export var blue_scatter_target_paths: Array = [
	"../../MovementTargets/BlueGhost/Scatter/Blue1", 
	"../../MovementTargets/BlueGhost/Scatter/Blue2", 
	"../../MovementTargets/BlueGhost/Scatter/Blue3", 
	"../../MovementTargets/BlueGhost/Scatter/Blue4"
]
@export var blue_home_target_paths: Array = [
	"../../MovementTargets/BlueGhost/Home/Top",  
	"../../MovementTargets/BlueGhost/Home/Bottom"
]
@export var yellow_scatter_target_paths: Array = [
	"../../MovementTargets/YellowGhost/Scatter/Yellow1", 
	"../../MovementTargets/YellowGhost/Scatter/Yellow2", 
	"../../MovementTargets/YellowGhost/Scatter/Yellow3", 
	"../../MovementTargets/YellowGhost/Scatter/Yellow4"
]
@export var yellow_home_target_paths: Array = [
	"../../MovementTargets/YellowGhost/Home/Top",  
	"../../MovementTargets/YellowGhost/Home/Bottom"
]
@export var pink_scatter_target_paths: Array = [
	"../../MovementTargets/PinkGhost/Scatter/Pink1", 
	"../../MovementTargets/PinkGhost/Scatter/Pink2", 
	"../../MovementTargets/PinkGhost/Scatter/Pink3", 
	"../../MovementTargets/PinkGhost/Scatter/Pink4"
]
@export var pink_home_target_paths: Array = [
	"../../MovementTargets/PinkGhost/Home/Top",  
	"../../MovementTargets/PinkGhost/Home/Bottom"
]

#onready variables
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_timer = $ScatterTimer
@onready var update_chasing_target_position_timer = $UpdateChasingTargetPositionTimer
@onready var run_away_timer = $RunAwayTimer
@onready var eyes_sprite = $EyesSprite as EyesSprite
@onready var body_sprite = $BodySprite as BodySprite
@onready var points_label = $PointsLabel
@onready var at_home_timer = $AtHomeTimer

func _ready():	
	scatter_timer.wait_time = scatter_wait_time
	at_home_timer.wait_time = at_home_wait_time
	
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)
	
	body_sprite.texture = starting_texture
	
	if not tile_map:
		print("Error: TileMap is not assigned in the editor.")
		return
	
	var scatter_target_paths
	var home_target_paths
	
	var red = "ff7463ff"
	var blue = "8fb4ffff"
	var pink = "ffaafeff"
	var yellow = "ffb956ff"
	
	if color.to_html() == red:
		scatter_target_paths = red_scatter_target_paths
		home_target_paths = red_home_target_paths
	elif color.to_html() == blue:
		scatter_target_paths = blue_scatter_target_paths
		home_target_paths = blue_home_target_paths
	elif color.to_html() == pink:
		scatter_target_paths = pink_scatter_target_paths
		home_target_paths = pink_home_target_paths
	elif color.to_html() == yellow:
		scatter_target_paths = yellow_scatter_target_paths
		home_target_paths = yellow_home_target_paths
		
	for path in scatter_target_paths:
		var target = get_node_or_null(path)
		if target:
			scatter_targets.append(target)
		else:
			print("Error: Could not find scatter target at path:", path)
	
	for path in home_target_paths:
		var target = get_node_or_null(path)
		if target:
			home_targets.append(target)
		else:
			print("Error: Could not find home target at path:", path)
	
	
	var player = $"../../Player"
	chasing_target = player
	
	if game_manager.get_current_level() > 5:
		speed = 150
	
	call_deferred("setup")
	
func setup():		
	run_away_timer.stop()
	scatter_timer.stop()
	at_home_timer.stop()
	update_chasing_target_position_timer.stop()			
	
	current_at_home_index = 0
			
	set_collision_mask_value(1, true)
	set_collision_layer_value(5, true)
	var nav_map = tile_map.get_navigation_map(0)
	if not nav_map:
		print("Error: Navigation map is null.")
		return
	eyes_sprite.show_eyes()
	body_sprite.move()
	position = starting_position.global_position
	
	
	var pink = "ffaafeff"
	if color.to_html() == pink:
		move_to_next_home_position()
	navigation_agent_2d.set_navigation_map(nav_map)
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), nav_map)    
	
	if is_starting_at_home:
		start_at_home()
	else:
		scatter()

func start_at_home():
	current_state = GhostState.STARTING_AT_HOME
	at_home_timer.start()
	navigation_agent_2d.target_position = home_targets[current_at_home_index].global_position
	
func scatter():
	scatter_timer.start()
	current_state = GhostState.SCATTER
	if current_scatter_index >= 0 and current_scatter_index < scatter_targets.size():
		navigation_agent_2d.target_position = scatter_targets[current_scatter_index].global_position
	else:
		print("Error: Scatter target index out of range.")

func on_position_reached():
	if current_state == GhostState.SCATTER:
		if current_scatter_index < 3:
			current_scatter_index += 1
		else: 
			current_scatter_index = 0
		navigation_agent_2d.target_position = scatter_targets[current_scatter_index].global_position
	elif current_state == GhostState.RUN_AWAY:
		run_to_new_random_point()
	elif current_state == GhostState.EATEN:
		start_chasing_pacman_after_being_eaten()
	elif current_state == GhostState.STARTING_AT_HOME:
		move_to_next_home_position()

func _process(delta):
	if !run_away_timer.is_stopped() && run_away_timer.time_left < run_away_timer.wait_time / 2 && !is_blinking:
		start_blinking()
		
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)
	
func move_ghost(next_position: Vector2, delta: float):
	var current_ghost_position = global_position
	var current_speed = eaten_speed if current_state == GhostState.EATEN else speed
	var new_velocity = (next_position - current_ghost_position).normalized() * current_speed * delta
	
	calculate_direction(new_velocity)
	
	position += new_velocity

func calculate_direction(new_velocity: Vector2):
	var current_direction
	
	if new_velocity.x > 1:
		current_direction = "right"
	elif new_velocity.x < -1:
		current_direction = "left"
	elif new_velocity.y > 1:
		current_direction = "down"
	elif new_velocity.y < -1:
		current_direction = "up"
		
	if current_direction != direction:
		direction = current_direction
		direction_change.emit(direction)

func _on_scatter_timer_timeout():
	start_chasing_pacman()
	
func start_chasing_pacman():
	current_state = GhostState.CHASE
	update_chasing_target_position_timer.start()
	navigation_agent_2d.target_position = chasing_target.position

func _on_update_chasing_target_position_timer_timeout():
	navigation_agent_2d.target_position = chasing_target.position

func run_away_from_pacman():
	if current_state != GhostState.EATEN:
		if run_away_timer.is_stopped():
			body_sprite.run_away()
			eyes_sprite.hide_eyes()
			run_away_timer.start()
		elif current_state == GhostState.RUN_AWAY:
			body_sprite.run_away()
			run_away_timer.stop()
			run_away_timer.wait_time = 8
			run_away_timer.start()
			
		
		current_state = GhostState.RUN_AWAY
		
		update_chasing_target_position_timer.stop()
		scatter_timer.stop()
		
		run_to_new_random_point()

func run_to_new_random_point():
	var empty_cell_position = tile_map.get_random_empty_cell_position()
	navigation_agent_2d.target_position = empty_cell_position

func _on_run_away_timer_timeout():
	is_blinking = false
	eyes_sprite.show_eyes()
	body_sprite.move()
	start_chasing_pacman()
	points_manager.reset_ghost_points()

func start_blinking():
	body_sprite.start_blinking()

func _on_body_entered(body):
	var player = body as Player
	if current_state == GhostState.RUN_AWAY:
		get_eaten()
	elif current_state == GhostState.CHASE or current_state == GhostState.SCATTER:
		set_collision_mask_value(1, false)
		update_chasing_target_position_timer.stop()
		player.die()
		scatter_timer.stop()  # Ensure scatter timer stops
		scatter_timer.wait_time = 10  # Set a short wait time to switch to chase quickly
		scatter_timer.start()  # Restart the timer for a short period
		scatter()

func get_eaten():
	ghost_eaten_sound_player.play()
	body_sprite.hide()
	eyes_sprite.show_eyes()
	points_label.text = str(points_manager.points_for_ghost_eaten)
	points_label.show()
	await points_manager.pause_on_ghost_eaten()
	points_label.hide()
	run_away_timer.stop()
	current_state = GhostState.EATEN
	navigation_agent_2d.target_position = home_targets[1].global_position
	
func start_chasing_pacman_after_being_eaten():
	start_chasing_pacman()
	body_sprite.show()
	body_sprite.move()

func move_to_next_home_position():
	current_at_home_index = 1 if current_at_home_index == 0 else 0
	navigation_agent_2d.target_position = home_targets[current_at_home_index].global_position

func _on_at_home_timer_timeout():
	scatter()  # Move to scatter state instead of staying at home indefinitely
