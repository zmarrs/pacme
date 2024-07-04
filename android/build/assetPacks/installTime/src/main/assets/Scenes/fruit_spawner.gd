extends Area2D

class_name FruitSpawner

@onready var points_manager = $".."
@onready var points_label = $PointsLabel
@onready var hide_label_timer = $HideLabelTimer
@onready var sprite_2d = $Sprite2D

var fruit_type = 0

func _ready():
	set_score_label()

func set_score_label():
	match fruit_type:
		1:
			points_label.text = str(500)
		2: 
			points_label.text = str(100)
		3:
			points_label.text = str(250)
		4: 
			points_label.text = str(1000)
		5:
			points_label.text = str(2500) 
		6: 
			points_label.text = str(1500) 
		7:
			points_label.text = str(3000) 
		8: 
			points_label.text = str(5000) 

func _on_body_entered(body):
	if body is Player:
		points_manager.fruit_points(fruit_type)	
		sprite_2d.hide()
		points_label.show()
		hide_label_timer.start()
		
func _on_hide_label_timer_timeout():
	points_label.hide()
	queue_free()
