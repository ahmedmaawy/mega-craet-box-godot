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
		spawn_bullet()
		$ShootCooldownTimer.start()


# Cool
func cool_weapon():
	pass


# Spawn a bullet
func spawn_bullet():
	Audio.sfx_play_bullet()
	var bullet_instance = bullet.instance()
	bullet_instance.is_flipped = is_flipped
	Globals.spawn_ammo(bullet_instance, $SpawnPosition.global_position)


# Fire
func _on_ShootCooldownTimer_timeout():
	can_spawn = true
