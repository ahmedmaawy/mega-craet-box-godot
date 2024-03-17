extends "res://weapons/weapon_base.gd"

const bullet = preload("res://ammo/bullet.tscn")

var can_spawn = true


# Set no attachment force
func _ready():
	._ready()
	attached_player.attachment_force_active = false


# Fire
func fire_weapon():
	if can_spawn:
		can_spawn = false
		Audio.sfx_play_bullet()
		spawn_bullets()
		$ShootCooldownTimer.start()


# Cool
func cool_weapon():
	pass


# Spawn a bullet
func spawn_bullets():
	Audio.sfx_play_bullet()
	var bullet_instance_1 = bullet.instance()
	var bullet_instance_2 = bullet.instance()
	
	bullet_instance_2.is_flipped = true
	
	Globals.spawn_ammo(bullet_instance_1, $SpawnPosition1.global_position)
	Globals.spawn_ammo(bullet_instance_2, $SpawnPosition2.global_position)


# Override the flip with nothing to do
func flip_weapon():
	pass


# Fire
func _on_ShootCooldownTimer_timeout():
	can_spawn = true
