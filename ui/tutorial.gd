extends Node2D

signal tutorial_done

onready var screen_text_label = $ScreenText
onready var title_label = $Title/TitleLabel

onready var tutorial_rects = [
	$Rects/PlayerRect,
	$Rects/CrateRect,
	$Rects/EnemyRect,
	$Rects/FireEnemyRect,
]

const tutorial_texts = [
	"This is the player. The player is always armed with a weapon",
	"The player gets points collecting crates. Each crate arms the player with a random weapon. Collect more crates to unlock locked weapons",
	"Enemies are dropped into the scene. You need to kill them before they reach the fire",
	"Once enemies reach the fire - they are brought back to the scene angier and on fire",
]

const tutorial_titles = [
	"Player",
	"Crates",
	"Enemy",
	"Fire Enemy"
]

var current_step = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	current_step = 1
	activate_step()


# Activate the current tutorial rect
func activate_step():
	title_label.text = tutorial_titles[current_step - 1]
	screen_text_label.text = tutorial_texts[current_step - 1]
	
	for rect in tutorial_rects:
		rect.hide()
	
	tutorial_rects[current_step - 1].show()


# Next button has been pressed
func next_pressed():
	if current_step < tutorial_texts.size():
		Audio.sfx_play_menu()
		current_step += 1
		activate_step()


# Next button has been pressed
func prev_pressed():
	if current_step > 1:
		Audio.sfx_play_menu()
		current_step -= 1
		activate_step()


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
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		emit_signal("tutorial_done")
		queue_free()

