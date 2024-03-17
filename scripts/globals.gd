extends Node

# Enums
enum GameDifficulty {
	EASY,
	MEDIUM,
	HARD
}

# Game Weapon Enumerator
enum GameWeapon {
	BAZOOKA,
	DISK_GUN,
	DUAL_PISTOL,
	# FLAME_THROWER,  # 1
	GRANADE_LAUNCHER,
	KATANA,
	# LASER_GUN, # 2
	MACHINE_GUN,
	MINES,
	PISTOL,
	SHOTGUN
}

# Enemy kind enums
enum EnemyKind {
	BIRD,
	GOBLIN,
	GOBLIN_SMALL
}

# Game weapon names
const game_weapon_names = {
	GameWeapon.BAZOOKA : "Bazooka",
	GameWeapon.DISK_GUN : "Disk Gun",
	GameWeapon.DUAL_PISTOL : "Dual Pistols",
	# GameWeapon.FLAME_THROWER : "Flame Thrower",
	GameWeapon.GRANADE_LAUNCHER : "Grenade Launcher",
	GameWeapon.KATANA : "Katana",
	# GameWeapon.LASER_GUN : "Lazer Gun",
	GameWeapon.MACHINE_GUN : "Machine Gun",
	GameWeapon.MINES : "Mines",
	GameWeapon.PISTOL : "Pistol",
	GameWeapon.SHOTGUN : "Shotgun"
}

# Import utilities
const util = preload('res://scripts/util.gd')
const firebase_server_id = 'default'

# Auto enabled weapons
const auto_enabled_weapons = [
	GameWeapon.PISTOL,
	GameWeapon.MACHINE_GUN,
	GameWeapon.SHOTGUN
]

# Keeps track of enabled weapons
var enabled_weapons = []

# Signals
signal player_fire
signal crate_picked(is_initialization)
signal player_killed(player_position, enemy_position, is_inverted)
signal enemy_killed(enemy_kind, kill_position, horizontal_speed, 
	impulse_force, vertical_force, is_inverted)
signal spawn_ammo_object(ammo_object, position)
signal spawn_game_object(game_object, position)
signal screen_shake(trauma, decay, max_offset, max_roll)

var is_player_killed = false

# Difficulty
var game_difficulty = GameDifficulty.HARD

# Other variables
var settings_config
var game_state_config
var is_crate_pickable = true
var num_crates = 0
var current_level_num_crates = 0
var current_stage = 1
var num_birds_spawned = 0
var username = ""

# Misc config
var multiple_enemy_spawn_mode = false
var num_multiple_enemies_to_spawn = 2

# Config files
const settings_config_file = "user://settings_" + firebase_server_id + ".cfg"
const state_config_file = "user://state_" + firebase_server_id + ".cfg"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_game_config()


# Load weapon config
func load_weapon_config():
	enabled_weapons.clear()
	
	for weapon_item in auto_enabled_weapons:
		enabled_weapons.append(Globals.GameWeapon.keys()[weapon_item])
	
	for weapon_item in GameWeapon:
		if not weapon_item in enabled_weapons:
			if get_weapon_enabled(weapon_item):
				enabled_weapons.append(weapon_item)


# Loads game configuration
func load_game_config():
	settings_config = ConfigFile.new()
	game_state_config = ConfigFile.new()
	
	# Config loading errors
	var settings_err = settings_config.load(settings_config_file)
	var game_state_err = game_state_config.load(state_config_file)
	
	# Load user name
	username = get_username()
	
	# Initialize game settings if it does not exist
	if settings_err != OK:
		set_game_difficulty(GameDifficulty.EASY)
	
	# Initialize state if it does not exist
	if game_state_err != OK:
		set_num_crates(0)
		set_level_enabled(1, true)
		set_level_enabled(2, false)
		set_level_enabled(3, false)
	
	if game_state_err != OK or settings_err != OK:
		settings_config.load(settings_config_file)
		game_state_config.load(state_config_file)
	
	# Load global configs
	game_difficulty = get_game_difficulty()
	num_crates = get_num_crates()
	
	# Load weapon configuration
	load_weapon_config()


# Save user name
func set_username(username, username_with_uuid):
	# Save user to firebase
	FirebaseOperations.save_user(username, username_with_uuid)
	# Save user to state
	save_state_config("user", {
		"username": username_with_uuid,
		"username_plain": username,
	})


func get_username():
	if game_state_config.has_section_key("user", "username"):
		var username = game_state_config.get_value("user", "username")
		return username
	else:
		return false


func get_username_plain():
	if game_state_config.has_section_key("user", "username"):
		var username = game_state_config.get_value("user", "username_plain")
		return username
	else:
		return false


# Save game difficulty level
func set_game_difficulty(level):
	save_settings_config("settings", {
		"difficulty": level
	})


func get_game_difficulty():
	if settings_config.has_section_key("settings", "difficulty"):
		var difficulty = settings_config.get_value("settings", "difficulty")
		return difficulty
	else:
		set_game_difficulty(GameDifficulty.EASY)
		return GameDifficulty.EASY


# Save the number of crates
func set_num_crates(num_crates_setting):
	save_state_config("crates", {
		"num_crates": num_crates_setting
	})


func get_num_crates():
	if game_state_config.has_section_key("crates", "num_crates"):
		var game_num_crates = game_state_config.get_value("crates", "num_crates")
		return game_num_crates
	else:
		set_num_crates(0)
		return 0


# Save the number of crates
func set_level_num_crates(num_crates_setting, level, difficulty):
	# Save to firebase
	FirebaseOperations.save_user_level_highscore(username, level, difficulty, 
		num_crates_setting)
	# Save to state
	save_state_config("crates", {
		"level_" + String(level) + "_num_crates_" + String(difficulty): num_crates_setting
	})


func get_level_num_crates(level, difficulty):
	var config_item = "level_" + String(level) + "_num_crates_" + String(difficulty)
	
	if game_state_config.has_section_key("crates", config_item):
		var level_num_crates = game_state_config.get_value("crates", config_item)
		return level_num_crates
	else:
		set_level_num_crates(0, level, difficulty)
		return 0


# Enables or disables a weapon
func set_weapon_enabled(weapon, enabled):
	save_state_config("weapons", {
		weapon: enabled
	})


func get_weapon_enabled(weapon):
	if game_state_config.has_section_key("weapons", weapon):
		var weapon_enabled = game_state_config.get_value("weapons", weapon)
		return weapon_enabled
	else:
		set_weapon_enabled(weapon, false)
		return false


# Enables or disables a level
func set_level_enabled(level, enabled):
	save_state_config("levels", {
		level: enabled
	})


func get_level_enabled(level):
	if game_state_config.has_section_key("levels", String(level)):
		var level_enabled = game_state_config.get_value("levels", String(level))
		return level_enabled
	else:
		set_level_enabled(level, false)
		return false


# Save settings configuration
func save_settings_config(root_config, configs):
	for config_item in configs:
		settings_config.set_value(root_config, config_item, configs[config_item])
	
	settings_config.save(settings_config_file)


# Save game state configuration
func save_state_config(root_config, configs):
	for config_item in configs:
		game_state_config.set_value(root_config, String(config_item), configs[config_item])
	
	game_state_config.save(state_config_file)


# Body entered the fire
func fire_body_entered(body):
	if body.is_in_group("player"):
		is_player_killed = true
		emit_signal("player_fire")
		body.queue_free()
	elif body.is_in_group("enemy"):
		body.queue_free()


# Global notifications for crate picking
func crate_picked():
	emit_signal("crate_picked", false)


# Initialization of the levels
func initialize_level():
	emit_signal("crate_picked", true)
	num_birds_spawned = 0
	current_level_num_crates = 0


# Player has been killed
func kill_player(player_position, enemy_position, is_inverted):
	emit_signal("player_killed", player_position, 
		enemy_position, is_inverted)
	is_player_killed = true


# Enemy has been killed
func kill_enemy(enemy_kind, kill_position, horizontal_speed, 
	impulse_force, vertical_force, is_inverted):
	emit_signal("enemy_killed", enemy_kind, kill_position,
		horizontal_speed, impulse_force, vertical_force, is_inverted)


# Gets a random weapon
func get_random_weapon():
	randomize()
	var num_weapons = enabled_weapons.size()
	var weapon_ref = randi() % num_weapons
	return enabled_weapons[weapon_ref]


# Spawn ammo object
func spawn_ammo(ammo_object, global_pos):
	emit_signal("spawn_ammo_object", ammo_object, global_pos)


# Spawn game object
func spawn_object(game_object, global_pos):
	emit_signal("spawn_game_object", game_object, global_pos)


# Do a screen shake
func do_screen_shake(trauma = -1, decay = -1, max_offset = Vector2(-1, -1), max_roll = -1):
	emit_signal("screen_shake", trauma, decay, max_offset, max_roll)
