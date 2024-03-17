extends "res://enemies/walking_enemies.gd"

# Tracks enemy is_on_floor status
var floored = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	is_flipped = randi() % 2
	animated_sprite.play("run")
	
	match Globals.game_difficulty:
		Globals.GameDifficulty.HARD:
			speed = 250
		Globals.GameDifficulty.MEDIUM:
			speed = 180
		Globals.GameDifficulty.EASY:
			speed = 120
	
	if is_fire:
		animated_sprite.modulate = Color(1, 0, 0, 1)
		speed *= 1.5


# Physics
func _physics_process(delta):
	._physics_process(delta)
	
	if is_on_floor() != floored:
		floored = is_on_floor()
		
		if floored:
			Globals.do_screen_shake()
			Audio.sfx_enemy_drop()
