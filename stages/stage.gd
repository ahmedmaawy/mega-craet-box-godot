extends Node2D

signal spawn_fire_activated(body)

# Crate alignment Plus
export var crate_alignment : Vector2 = Vector2(40, 50)
export var max_num_birds : int = 2

# Variables
onready var player = $Characters/Player

var pickups_tilemap = null
var crate_scene = preload("res://pickups/crate.tscn")
var num_crates = 0

var spawn_placeholder = null

var enemies = [
	preload("res://enemies/bird.tscn"),
	preload("res://enemies/goblin.tscn"),
	preload("res://enemies/goblin_small.tscn")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	if has_node("PickupsMap"):
		pickups_tilemap = $PickupsMap
	
	if pickups_tilemap != null:
		pickups_tilemap.visible = false
	
	if has_node("Placeholders/Position2D"):
		spawn_placeholder = $Placeholders/Position2D
	
	generate_crates()
	
	Globals.initialize_level()


# Spawn a crate
func spawn_crate(tile_position: Vector2):
	var crate_instance = crate_scene.instance()
	crate_instance.position = tile_position * Vector2(64, 64) + crate_alignment
	crate_instance.visible = false
	$Crates.call_deferred("add_child", crate_instance)
	
	# Total crates
	num_crates += 1


# Generate crates
func generate_crates():
	for tile_position in pickups_tilemap.get_used_cells():
		if pickups_tilemap.get_cellv(tile_position) == pickups_tilemap.tile_set.find_tile_by_name("chest.png 23"):
			spawn_crate(tile_position)


# Respawn crate
func respawn_crate():
	randomize()
	var crate = $Crates.get_child(randi() % num_crates)
	crate.visible = true
	crate.enable_collider()


# Spawn an enemy
func spawn_enemy(is_fire = false, override_health = false, body_type = -1, health_guage = 100):
	var num_enemies = 1
	
	if Globals.multiple_enemy_spawn_mode:
		# Option B: Spawn x number of enemies at one
		randomize()
		num_enemies = (randi() % Globals.num_multiple_enemies_to_spawn) + 1
	
	for loop_item in range(0, num_enemies):
		if not Globals.is_player_killed:
			if spawn_placeholder != null:
				randomize()
				
				# Determine enemy type
				var enemy_type = body_type
				
				if enemy_type == -1:
					enemy_type = randi() % enemies.size()
				
				# Spawn the enemy
				var new_enemy = enemies[enemy_type]
				var enemy_instance = new_enemy.instance()
				enemy_instance.position = spawn_placeholder.position
				enemy_instance.is_fire = is_fire
				
				if override_health:
					enemy_instance.health_guage = health_guage
				
				if enemy_type == 0 and Globals.num_birds_spawned >= max_num_birds:
					enemy_type += (randi() % 2) + 1
				
				if enemy_type == 0:
					enemy_instance.player_killed = false
					enemy_instance.player = player
				
				$Characters.call_deferred("add_child", enemy_instance)
				
				if Globals.multiple_enemy_spawn_mode:
					# Activate this if spawning more than one enemy at one go
					$SpawnYieldTimer.start()
					yield($SpawnYieldTimer, "timeout")


# Body entered the fire
func _on_Fire_body_entered(body):
	if body.is_in_group("enemy"):
		if body.health_guage >= 0:
			emit_signal("spawn_fire_activated", body)
