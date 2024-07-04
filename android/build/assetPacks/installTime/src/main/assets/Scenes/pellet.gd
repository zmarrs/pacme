extends Area2D

class_name Pellet

signal pellet_eaten(allow_eating_ghosts: bool)

@export var allow_eating_ghosts = false
@onready var points_manager = $"../../PointsManager"

func _on_body_entered(body):
	if body is Player:
		pellet_eaten.emit(allow_eating_ghosts)
		queue_free()
		points_manager.pellet_points()
