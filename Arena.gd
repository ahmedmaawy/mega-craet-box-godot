extends Node2D

# Exports
export var current_stage : PackedScene

# Variables
onready var stage = $Stage
onready var crate_respawn_timer = $CrateRespawn
onready var enemy_spawn_timer = $EnemySpawn

var stage_instance = null
var fire_spawners = []

var is_game_over = false

# Scene Constants
const player_rigid = preload("res://player/player_rigid.tscn")
const enemy_rigid = preload("res://enemies/enemy_rigid.tscn")
# Camera Constants
const default_camera_decay = 0.8
const default_camera_max_offset = Vector2(100, 75)
const default_camera_max_roll = 0.1
const default_camera_trauma = 0.3

export (bool) var wait_for_game_over_audio = false
export (bool) var wait_for_game_over_timer = true
export (int) var wait_for_game_over_time = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if not current_stage:
		match Globals.current_stage:
			1:
				current_stage = load("res://stages/stage_a.tscn")
			2:
				current_stage = load("res://stages/stage_b.tscn")
			3:
				current_stage = load("res://stages/stage_c.tscn")
	
	stage_instance = current_stage.instance()
	stage_instance.connect("spawn_fire_activated", self, "_on_spawn_fire_activated")
	stage.call_deferred("add_child", stage_instance)
	
	Globals.connect("player_fire", self, "on_player_fire")
	Globals.connect("crate_picked", self, "on_crate_picked")
	Globals.connect("player_killed", self, "on_player_killed")
	Globals.connect("enemy_killed", self, "on_enemy_killed")
	Globals.connect("spawn_ammo_object", self, "on_spawn_ammo_object")
	Globals.connect("spawn_game_object", self, "on_spawn_game_object")
	Globals.connect("screen_shake", self, "on_screen_shake")
	
	enemy_spawn_timer.start()
	is_game_over = false
	Globals.is_player_killed = false
	
	Audio.audio_play_game()


# Track inputs
func _input(event):
	if is_game_over:
		if event.is_action_pressed("ui_accept"):
			get_tree().reload_current_scene()
		elif event.is_action_pressed("ui_cancel"):
			get_tree().change_scene("res://ui/main_menu.tscn")


# Create game over after timeout
func do_game_over_timeout():
	# Save state
	var current_num_crates = Globals.get_level_num_crates(Globals.current_stage, 
		Globals.game_difficulty)
	
	if Globals.current_level_num_crates > current_num_crates:
		Globals.set_level_num_crates(Globals.current_level_num_crates, 
			Globals.current_stage, Globals.game_difficulty)
	
	# Play Game Over
	Audio.audio_game_over()
	
	# Wait for game over audio?
	if wait_for_game_over_audio:
		yield(Audio, "game_over_finished")
	
	# Implement a game over timer
	if wait_for_game_over_timer:
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = wait_for_game_over_time
		
		$Timers.add_child(timer)
		
		timer.start()
		yield(timer, "timeout")
		
		timer.queue_free()
	
	is_game_over = true


# Player entered the fire
func on_player_fire():
	do_game_over_timeout()


# 1 second to respawn crate
func on_crate_picked(is_initialization):
	crate_respawn_timer.start()


# Respawn crate
func _on_CrateRespawn_timeout():
	if stage_instance.has_method("respawn_crate"):
		stage_instance.respawn_crate()
		crate_respawn_timer.stop()


# When it times out
func _on_EnemySpawn_timeout():
	enemy_spawn_timer.wait_time = (randi() % 2) + 1
	
	if stage_instance.has_method("spawn_enemy"):
		stage_instance.spawn_enemy(false, false)


# Player killed
func on_player_killed(player_position, enemy_position, is_inverted):
	var player_instance = player_rigid.instance()
	player_instance.position = player_position
	player_instance.enemy_position = enemy_position
	player_instance.flipped = is_inverted
	player_instance.torque = -2
	
	if enemy_position.x < player_position.x:
		# The other side
		player_instance.impulse.x *= -1
		player_instance.torque *= -1
	
	$Objects.call_deferred("add_child", player_instance)
	
	do_game_over_timeout()


# Enemy killed
func on_enemy_killed(enemy_kind, enemy_position, horizontal_speed, 
	impulse_force, vertical_force, is_inverted):
	var enemy_instance = enemy_rigid.instance()
	enemy_instance.enemy_kind = enemy_kind
	enemy_instance.position = enemy_position
	enemy_instance.horizontal_speed = horizontal_speed
	enemy_instance.impulse_force = impulse_force
	enemy_instance.upward_thrust = vertical_force
	enemy_instance.flipped = is_inverted
	enemy_instance.torque = -2
	
	if is_inverted:
		# The other side
		enemy_instance.torque *= -1
	
	$Objects.call_deferred("add_child", enemy_instance)


# Spawn a body from the fire
func _on_spawn_fire_activated(body):
	var body_type = body.enemy_kind
	var health_guage = body.health_guage
	
	# Dont respawn enemies that came with fire
	if not body.is_fire:
		# Create a timer
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 1
		
		$Timers.add_child(timer)
		
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		
		# Wait for timeout
		if stage_instance.has_method("spawn_enemy"):
			stage_instance.spawn_enemy(true, true, body_type, health_guage)


# Spawn an ammo object
func on_spawn_ammo_object(object, global_pos):
	object.global_position = global_pos
	$Ammo.call_deferred("add_child", object)


# Spawn an ammo object
func on_spawn_game_object(object, global_pos):
	object.global_position = global_pos
	$GameObjects.call_deferred("add_child", object)


# Screen shake
func on_screen_shake(trauma, decay, max_offset, max_roll):
	var decay_val = default_camera_decay
	var max_offset_val = default_camera_max_offset
	var max_roll_val = default_camera_max_roll
	var trauma_val = default_camera_trauma
	
	if decay != -1:
		decay_val = decay
	
	if max_offset != Vector2(-1, -1):
		max_offset_val = max_offset
	
	if max_roll != -1:
		max_roll_val = max_roll
	
	if trauma != -1:
		trauma_val = trauma
	
	$ArenaCamera.decay = decay_val
	$ArenaCamera.max_offset = max_offset_val
	$ArenaCamera.max_roll = max_roll_val
	$ArenaCamera.add_trauma(trauma_val)
	$ArenaCamera.shake()
