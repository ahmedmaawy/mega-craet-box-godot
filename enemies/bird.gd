extends KinematicBody2D

const enemy_type = 0

var player = null
var player_killed = true

export (float) var smooth_speed = 0.3
export (int) var spawn_reference_point = 520
export (bool) var is_fire = false
export (int) var health_guage = 20

var position_difference = Vector2()
var smoothed_velocity = Vector2()
var horizontal_speed = 0

var is_flipped = false

onready var animated_sprite = $AnimatedSprite

var rand_coordinates = [-10, 10]


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("fly")
	if not player_killed and player != null:
		Globals.connect("player_killed", self, "_on_player_killed")
		Globals.connect("player_fire", self, "_on_player_fire")
	
	
	match Globals.game_difficulty:
		Globals.GameDifficulty.HARD:
			smooth_speed = 0.15
		Globals.GameDifficulty.MEDIUM:
			smooth_speed = 0.2
		Globals.GameDifficulty.EASY:
			smooth_speed = 0.25
	
	# Not more than 2 birds max
	Globals.num_birds_spawned += 1


# When the player gets killed
func player_is_killed():
	player = null
	player_killed = true


# Pass
func _on_player_killed(player_position, enemy_position, is_inverted):
	player_is_killed()


# Player entered the fire
func _on_player_fire():
	player_is_killed()


# Kill the bird, reset the stats
func kill_bird():
	Globals.num_birds_spawned -= 1


# Reduce the health of the enemy
func reduce_health(amount, ammo_horizontal_speed, vertical_force, impulse_force):
	health_guage -= amount
	
	if health_guage <= 0:
		Globals.kill_enemy(Globals.EnemyKind.BIRD, 
			position, ammo_horizontal_speed, impulse_force, vertical_force,
			is_flipped)
		kill_enemy()
	else:
		animated_sprite.modulate = Color(1, 0, 0, 0.6)
		$CooldownTimer.start()


# Enemy killed
func kill_enemy():
	kill_bird()
	queue_free()


# Physics process
func _physics_process(delta):
	if (not Globals.is_player_killed) and (player != null):
		var player_position = player.get("position")
		var destination = player_position

		position_difference = destination - position
		smoothed_velocity = position_difference * smooth_speed * delta

		horizontal_speed = smoothed_velocity.x

		var collision = move_and_collide(smoothed_velocity)


# Return back
func _on_CooldownTimer_timeout():
	animated_sprite.modulate = Color(1, 1, 1, 1)
