extends "res://weapons/weapon_base.gd"

const bullet = preload("res://ammo/bullet.tscn")


# Set no attachment force
func _ready():
	._ready()
	attached_player.attachment_force_active = false


# Fire
func fire_weapon():
	var bullet_1 = bullet.instance()
	var bullet_2 = bullet.instance()
	var bullet_3 = bullet.instance()
	
	var rotation_degrees_1 = 15
	var rotation_degrees_3 = -25
	
	bullet_1.rotation_degrees = rotation_degrees_1
	bullet_3.rotation_degrees = rotation_degrees_3
	
	# Need to take more damage
	bullet_1.damage = 60
	bullet_2.damage = 60
	bullet_3.damage = 60
	
	# Need to be timed
	bullet_1.timed = true
	bullet_2.timed = true
	bullet_3.timed = true
	
	# Need to be timed
	bullet_1.is_flipped = is_flipped
	bullet_2.is_flipped = is_flipped
	bullet_3.is_flipped = is_flipped
	
	Audio.sfx_play_bullet()
	
	Globals.spawn_ammo(bullet_1, $SpawnPosition.global_position)
	Globals.spawn_ammo(bullet_2, $SpawnPosition.global_position)
	Globals.spawn_ammo(bullet_3, $SpawnPosition.global_position)


# Cool
func cool_weapon():
	pass
