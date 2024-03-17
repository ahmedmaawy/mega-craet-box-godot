extends Node2D

# Variables
var difficulty_game_menu = preload("res://ui/menus/difficulty_menu.tscn")
var settings_game_menu = preload("res://ui/menus/settings_menu.tscn")
var game_menu = preload("res://ui/menus/game_main_menu.tscn")
var stages_game_menu = preload("res://ui/menus/stages_menu.tscn")
var tutorial_screen = preload("res://ui/tutorial.tscn")
var unlocks_screen = preload("res://ui/unlocks.tscn")

# Placeholder for current menu node
var current_menu = null
var is_initializing = true

# User name screen
const username_screen = preload("res://ui/username.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# If username is not set then set it 1st
	if typeof(Globals.username) != TYPE_STRING:
		if Globals.username == false:
			var username_screen_instance = username_screen.instance()
			username_screen_instance.connect("username_set", self, "_on_username_set")
			$UI.call_deferred("add_child", username_screen_instance)
			yield(username_screen_instance, "username_set")
		
	
	# Continue to initialization
	is_initializing = true
	show_main_menu()
	Audio.audio_play_menu()
	is_initializing = false


# Show main menu
func show_main_menu():
	if not is_initializing:
		Audio.sfx_play_menu()
	
	if current_menu != null:
		current_menu.queue_free()
	
	var main_menu = game_menu.instance()
	main_menu.get_node("GameMenu").connect("item_selected", self, "_on_GameMenu_item_selected")
	current_menu = main_menu
	
	call_deferred("add_child", main_menu)


# Show settings menu
func show_settings_menu():
	Audio.sfx_play_menu()
	
	current_menu.queue_free()
	
	var settings_menu = settings_game_menu.instance()
	settings_menu.get_node("SettingsMenu").connect("item_selected", self, "_on_SettingsMenu_item_selected")
	current_menu = settings_menu
	
	call_deferred("add_child", settings_menu)


# Show settings menu
func show_difficulty_menu():
	Audio.sfx_play_menu()
	
	current_menu.queue_free()
	
	var difficulty_menu = difficulty_game_menu.instance()
	difficulty_menu.get_node("DifficultyMenu").connect("item_selected", self, "_on_DifficultyMenu_item_selected")
	current_menu = difficulty_menu
	
	call_deferred("add_child", difficulty_menu)


# Displays the tutorial
func show_tutorial():
	Audio.sfx_play_menu()
	
	current_menu.queue_free()
	current_menu = null
	
	var tutorial_screen_instance = tutorial_screen.instance()
	tutorial_screen_instance.connect("tutorial_done", self, "_on_Tutorial_done")
	
	call_deferred("add_child", tutorial_screen_instance)


# Show settings menu
func show_stages_menu():
	Audio.sfx_play_menu()
	
	current_menu.queue_free()
	
	var stages_menu = stages_game_menu.instance()
	stages_menu.connect("stage_selected", self, "_on_StageMenu_stage_selected")
	current_menu = stages_menu
	
	call_deferred("add_child", stages_menu)


# Unlocks
func show_unlocks():
	Audio.sfx_play_menu()
	
	current_menu.queue_free()
	current_menu = null
	
	var unlocks_screen_instance = unlocks_screen.instance()
	unlocks_screen_instance.connect("unlocks_done", self, "_on_Unlocks_done")
	
	call_deferred("add_child", unlocks_screen_instance)


# Item in the menu selected
func _on_GameMenu_item_selected(item_index):
	match(item_index):
		0:
			# Show stages
			show_stages_menu()
		1:
			# Settings Menu
			show_settings_menu()
		2:
			# Tutorial
			show_tutorial()
		3:
			# Unlocks
			show_unlocks()
		4:
			# Quit
			get_tree().quit()

# Settings menu item selected
func _on_SettingsMenu_item_selected(item_index):
	match(item_index):
		0:
			# Difficulty Menu
			show_difficulty_menu()
		1:
			# Back to Main Menu
			show_main_menu()


func _on_DifficultyMenu_item_selected(item_index):
	match(item_index):
		0:
			Globals.set_game_difficulty(Globals.GameDifficulty.EASY)
			Globals.game_difficulty = Globals.GameDifficulty.EASY
		1:
			Globals.set_game_difficulty(Globals.GameDifficulty.MEDIUM)
			Globals.game_difficulty = Globals.GameDifficulty.MEDIUM
		2:
			Globals.set_game_difficulty(Globals.GameDifficulty.HARD)
			Globals.game_difficulty = Globals.GameDifficulty.HARD
		
	# Back to Main Menu
	show_main_menu()


# Stage has been selected
func _on_StageMenu_stage_selected(stage):
	Globals.current_stage = stage
	get_tree().change_scene("res://Arena.tscn")


# Show main menu
func _on_Tutorial_done():
	show_main_menu()


# Show main menu
func _on_Unlocks_done():
	show_main_menu()


# When username screen is used
func _on_username_set(username, username_with_uuid):
	Globals.set_username(username, username_with_uuid)
	Globals.username = username_with_uuid
