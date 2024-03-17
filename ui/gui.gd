extends Control

var num_crates : int = 0

# Variables
onready var score_label = $VBoxContainer/HBoxContainer1/Score
onready var message_label = $Message
onready var black_background_rect = $BlackBackground

# Game event messaging
const game_event_message = preload("res://ui/game_event_message.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("crate_picked", self, "on_crate_picked")
	Globals.connect("player_killed", self, "on_player_killed")
	Globals.connect("player_fire", self, "on_player_fire")
	
	GameRules.connect("level_unlocked", self, "on_level_unlocked")
	GameRules.connect("weapon_unlocked", self, "on_weapon_unlocked")
	
	black_background_rect.visible = false
	message_label.text = ""
	
	update_score()


# Update score on display
func update_score():
	score_label.text = String(num_crates)


# Crate picked
func on_crate_picked(is_initialization):
	if not is_initialization:
		num_crates += 1
		update_score()


# Game over
func game_over():
	message_label.text = "Game Over\n\nPress Enter Key to Restart\n\nor Esc to go back to Main Menu"
	black_background_rect.visible = true


# Player killed
func on_player_killed(player_position, enemy_position, is_inverted):
	game_over()


# Player is set on fire
func on_player_fire():
	game_over()


# Level has been unlocked
func on_level_unlocked(level):
	var message_instance = game_event_message.instance()
	message_instance.message_to_show = "Level " + String(level) + " unlocked"
	$Overlays.call_deferred("add_child", message_instance)


# Weapon has been unlocked
func on_weapon_unlocked(weapon):
	var message_instance = game_event_message.instance()
	print(weapon)
	message_instance.message_to_show = Globals.game_weapon_names[Globals.GameWeapon[weapon]] + " unlocked"
	$Overlays.call_deferred("add_child", message_instance)
