extends Node

signal game_over_finished

onready var game = $Background/Game
onready var menu = $Background/Menu


# Called when the node enters the scene tree for the first time.
func _ready():
	var strm = $Background/GameOver.stream as AudioStreamOGGVorbis
	strm.set_loop(false)


# SFX
func sfx_play_bazooka():
	$SFX/Bazooka.play()


func sfx_play_bullet():
	$SFX/Bullet.play()


func sfx_play_crate():
	$SFX/CratePick.play()


func sfx_play_disk():
	$SFX/DiskGun.play()


func sfx_play_grenade():
	$SFX/Grenade.play()


func sfx_play_jump():
	$SFX/Jump.play()


func sfx_play_menu():
	$SFX/Menu.play()


func sfx_enemy_drop():
	$SFX/EnemyDrop.play()


func sfx_mine_arm():
	$SFX/MineArm.play()


func sfx_katana_hit():
	$SFX/Katana.play()


func audio_play_menu():
	if game.playing:
		game.stop()
		
	menu.play()


func audio_play_game():
	if menu.playing:
		menu.stop()
		
	game.play()


func audio_game_over():
	if game.playing:
		game.stop()
	
	$Background/GameOver.play()


func _on_GameOver_finished():
	emit_signal("game_over_finished")
