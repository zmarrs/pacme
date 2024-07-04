extends Node

class_name PointsManager

var points_for_ghost_eaten = 200
var points = 0

@onready var power_pellet_sound_player = $"../SoundPlayers/PowerPelletSoundPlayer"
@onready var extra_life_sound_player = $"../SoundPlayers/ExtraLifeSoundPlayer"
@onready var fruit_sound_player = $"../SoundPlayers/FruitSoundPlayer"
@onready var ui = $"../UI"
@onready var player = $"../Player"
@onready var fruit_timer = $FruitTimer
@onready var game_manager = TheGameManager

func _ready():
	fruit_timer.start()
	points = game_manager.get_points()
	ui.set_score(points)
	var count_reduction = game_manager.extra_lives_earned * 10000
	game_manager.count_10000 = game_manager.get_points() - count_reduction

func pause_on_ghost_eaten():
	points += points_for_ghost_eaten
	game_manager.count_10000 += points_for_ghost_eaten
	ui.set_score(points)
	if game_manager.count_10000 > 9999:
		game_manager.count_10000 = 0
		game_manager.extra_lives_earned += 1
		player.lives += 1
		ui.set_lives(player.lives)
		extra_life_sound_player.play()
	get_tree().paused = true
	await get_tree().create_timer(0.7).timeout
	get_tree().paused = false
	points_for_ghost_eaten += 200

func reset_ghost_points():
	points_for_ghost_eaten = 200
	power_pellet_sound_player.stop()

func pellet_points():
	points += 10	
	game_manager.count_10000 += 10
	ui.set_score(points)	
	if points % 10000 == 0:
		game_manager.count_10000 = 0
		game_manager.extra_lives_earned += 1
		player.lives += 1
		ui.set_lives(player.lives)
		extra_life_sound_player.play()

func fruit_points(fruit_type):
	match fruit_type:
		1:
			points += 500
			game_manager.count_10000 += 500
		2: 
			points += 100
			game_manager.count_10000 += 100
		3:
			points += 250
			game_manager.count_10000 += 250
		4: 
			points += 1000
			game_manager.count_10000 += 1000
		5:
			points += 2500
			game_manager.count_10000 += 2500
		6: 
			points += 1500
			game_manager.count_10000 += 1500
		7:
			points += 3000
			game_manager.count_10000 += 3000
		8: 
			points += 5000
			game_manager.count_10000 += 5000
			
	fruit_sound_player.play()
	ui.set_score(points)	
	if game_manager.count_10000 > 9999:
		game_manager.count_10000 = 0
		game_manager.extra_lives_earned += 1
		player.lives += 1
		ui.set_lives(player.lives)
		extra_life_sound_player.play()
	fruit_timer.start()

func _on_fruit_timer_timeout():
	var new_fruit = preload("res://Scenes/fruit_spawner.tscn").instantiate()
	new_fruit.show()
	
	var dice_roll = randi() % 4 + 1  # Generate a random number between 1 and 6
	var texture_path = "res://Assets/Fruits/Fruit_Cherry.png"
	
	if game_manager.get_current_level() < 5:		
		match dice_roll:
			1:
				new_fruit.fruit_type = 1
				texture_path = "res://Assets/Fruits/Fruit_Strawberry.png"
			2:
				new_fruit.fruit_type = 2
				texture_path = "res://Assets/Fruits/Fruit_Cherry.png"
			3:
				new_fruit.fruit_type = 3
				texture_path = "res://Assets/Fruits/Fruit_Apple.png"
			4:
				new_fruit.fruit_type = 4
				texture_path = "res://Assets/Fruits/Fruit_Orange.png"
	else: 
		match dice_roll:
			1:
				new_fruit.fruit_type = 5
				texture_path = "res://Assets/Fruits/Fruit_Bell.png"
			2:
				new_fruit.fruit_type = 6
				texture_path = "res://Assets/Fruits/Fruit_Melon.png"
			3:	
				new_fruit.fruit_type = 7		
				texture_path = "res://Assets/Fruits/Fruit_Key.png"
			4:
				new_fruit.fruit_type = 8
				texture_path = "res://Assets/Fruits/Fruit_GalaxianStarship.png"
			
	var texture = load(texture_path)
	new_fruit.get_child(0).texture = texture	
			
	add_child(new_fruit)

func get_points():
	return points
