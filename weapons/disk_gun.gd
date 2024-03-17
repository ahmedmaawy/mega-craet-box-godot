extends "res://weapons/weapon_base.gd"

const disk = preload("res://ammo/disk.tscn")


# Set no attachment force
func _ready():
	._ready()
	attached_player.attachment_force_active = false


# Fire
func fire_weapon():
	Audio.sfx_play_disk()
	spawn_disk()


# Cool
func cool_weapon():
	pass


# Spawn a disk
func spawn_disk():
	var disk_instance = disk.instance()
	disk_instance.is_flipped = is_flipped
	Globals.spawn_ammo(disk_instance, $SpawnPosition.global_position)
