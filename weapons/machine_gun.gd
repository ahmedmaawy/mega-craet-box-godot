extends "res://weapons/weapon_base.gd"

export (int) var vertical_force = -200

const bullet = preload("res://ammo/bullet.tscn")

# Counts bullets
var bullet_counter = 0


func _ready():
	._ready()
	attached_player.attachment_velocity = Vector2(vertical_force, 0)
	attached_player.attachment_force_active = false


# Fire
func fire_weapon():
	spawn_bullet()
	attached_player.attachment_force_active = true
	$ShootCooldownTimer.start()


# Cool
func cool_weapon():
	attached_player.attachment_force_active = false
	$ShootCooldownTimer.stop()


# Spawn a bullet
func spawn_bullet():
	Audio.sfx_play_bullet()
	
	bullet_counter += 1
	
	var bullet_instance = bullet.instance()
	bullet_instance.is_flipped = is_flipped
	bullet_instance.damage = 60
	
	if bullet_counter >= 3:
		Globals.spawn_ammo(bullet_instance, $SpawnPositionHigh.global_position)
		bullet_counter = 0
	else:
		Globals.spawn_ammo(bullet_instance, $SpawnPosition.global_position)
	
	


# Shoot cooldown
func _on_ShootCooldownTimer_timeout():
	spawn_bullet()
