extends "res://enemies/walking_enemies.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	is_flipped = randi() % 2
	animated_sprite.play("run")
	
	match Globals.game_difficulty:
		Globals.GameDifficulty.HARD:
			speed = 200
		Globals.GameDifficulty.MEDIUM:
			speed = 150
		Globals.GameDifficulty.EASY:
			speed = 100
	
	if is_fire:
		animated_sprite.modulate = Color(1, 0, 0, 1)
		speed *= 1.5


# Physics
func _physics_process(delta):
	._physics_process(delta)
