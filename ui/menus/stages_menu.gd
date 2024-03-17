extends Node2D

# Signals
signal stage_selected(stage)

# Variables
var current_stage = 1
var level_2_enabled = false
var level_3_enabled = false
var current_level_enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	level_2_enabled = Globals.get_level_enabled(2)
	level_3_enabled = Globals.get_level_enabled(3)
	$LockedIcon.hide()
	$ScreenText.text = ""


func load_texture():
	var level_enabled = true
	
	match current_stage:
		1:
			$Sprite.texture = $Sprite.stage_1_texture
			$ScreenText.text = ""
		2:
			$Sprite.texture = $Sprite.stage_2_texture
			level_enabled = level_2_enabled
		3:
			$Sprite.texture = $Sprite.stage_3_texture
			level_enabled = level_3_enabled
	
	if level_enabled:
		$Sprite.modulate = Color(1, 1, 1, 1)
		$LockedIcon.hide()
	else:
		$Sprite.modulate = Color(1, 1, 1, 0.5)
		$LockedIcon.show()
		
		var message_string = " crate score needed to unlock this level from stage "
		
		match current_stage:
			2:
				message_string = String(GameRules.level2_unlock) + message_string + String(current_stage - 1)
			3:
				message_string = String(GameRules.level3_unlock) + message_string + String(current_stage - 1)
		
		$ScreenText.text = message_string
	
	$StageLabel.text = "Stage " + String(current_stage)
	current_level_enabled = level_enabled


# Next button has been pressed
func next_pressed():
	if current_stage < 3:
		Audio.sfx_play_menu()
		current_stage += 1
		load_texture()


# Next button has been pressed
func prev_pressed():
	if current_stage > 1:
		Audio.sfx_play_menu()
		current_stage -= 1
		load_texture()


# Prev button pressed
func _on_PrevButton_pressed():
	prev_pressed()


# Next button pressed
func _on_NextButton_pressed():
	next_pressed()


# Input handling
func _input(event):
	if event.is_action_pressed("ui_left"):
		prev_pressed()
	elif event.is_action_pressed("ui_right"):
		next_pressed()
	elif event.is_action_pressed("ui_accept"):
		# Only accept if current level is enabled
		if current_level_enabled:
			emit_signal("stage_selected", current_stage)
