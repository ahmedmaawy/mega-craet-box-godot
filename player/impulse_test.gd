extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.sleeping = true

# Testing
func _on_Timer_timeout():
	$Player.push($Player.position + Vector2(30, -20))
