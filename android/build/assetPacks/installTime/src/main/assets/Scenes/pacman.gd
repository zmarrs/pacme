extends CharacterBody2D
class_name Player

signal player_died(lives: int)
signal player_dying

# Variables
var next_movement_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()
var input_enabled: bool = false
var dying: bool = false

# Export variables
@export var speed = 280
@export var start_position: Node2D
@export var pacman_death_sound_player: AudioStreamPlayer2D
@export var pellets_manager: PelletsManager
@export var lives: int = 1
@export var ui: UI 

# Onready variables
@onready var direction_pointer = $DirectionPointer
@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var start_delay_timer = $StartDelayTimer
@onready var fruit_spawner = $"../PointsManager/FruitSpawner"
@onready var game_manager = TheGameManager
@onready var camera_2d = $"../Camera2D"
@onready var tile_map = $"../TileMap"
@onready var respawn_timer = $RespawnTimer

func _ready():
	fruit_spawner.queue_free()
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2
	ui.set_lives(lives)
	animation_player.play("Default")
	reset_player()
	start_delay_timer.start()
	lives = game_manager.get_lives()
	ui.set_lives(lives)
	
	camera_2d.swipe_detected.connect(_on_swipe_detected)

func _physics_process(delta):
	if input_enabled:
		get_input()
		
		if can_move_in_direction(next_movement_direction, delta):				
			movement_direction = next_movement_direction
			
		velocity = movement_direction * speed
		calculate_direction(velocity)
		move_and_slide()

func get_input():
	# Then detect the pressed action
	if Input.is_action_pressed("left"):
		next_movement_direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		next_movement_direction = Vector2.RIGHT	
	elif Input.is_action_pressed("up"):
		next_movement_direction = Vector2.UP
	elif Input.is_action_pressed("down"):
		next_movement_direction = Vector2.DOWN

func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 3)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0

func calculate_direction(new_velocity: Vector2):	
	if new_velocity.x > 1:
		rotation_degrees = 0
		sprite_2d.flip_h = true
	elif new_velocity.x < -1:
		rotation_degrees = 0
		sprite_2d.flip_h = false
	elif new_velocity.y > 1:
		rotation_degrees = 270
		sprite_2d.flip_h = false
	elif new_velocity.y < -1:
		rotation_degrees = 90
		sprite_2d.flip_h = false

func die():	
	if not dying:
		dying = true		
		set_collision_layer_value(1, false)
		set_collision_mask_value(5, false)
		set_physics_process(false) 
		pellets_manager.power_pellet_sound_player.stop()
		if not pacman_death_sound_player.playing:
			pacman_death_sound_player.play()	
		animation_player.play("death")
		player_dying.emit()

func _on_animation_player_animation_finished(anim_name):	
	lives -= 1
	game_manager.set_lives(lives)
	ui.set_lives(lives)
	if anim_name == "death":
		player_died.emit(lives)
		if lives != 0:
			reset_player()
		else:
			set_collision_layer_value(1, false)
		
func reset_player():
	animation_player.play("Default")
	position = start_position.global_position	
	set_collision_layer_value(1, true)
	set_collision_mask_value(5, true)
	set_physics_process(true)	
	rotation_degrees = 0
	sprite_2d.flip_h = false
	next_movement_direction = Vector2.ZERO
	movement_direction = Vector2.ZERO
	respawn_timer.start()

func _on_start_delay_timer_timeout():
	input_enabled = true

func _on_swipe_detected(direction: String):
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("up")
	Input.action_release("down")

	if direction == "down":
		Input.action_press("down")
	elif direction == "up":
		Input.action_press("up")
	elif direction == "right":
		Input.action_press("right")
	elif direction == "left":
		Input.action_press("left")

func _on_respawn_timer_timeout():
	dying = false


func _on_action_release_timer_timeout():
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("up")
	Input.action_release("down")
