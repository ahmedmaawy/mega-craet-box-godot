extends "res://weapons/weapon_base.gd"

const mine = preload("res://ammo/mine.tscn")

var can_spawn = true

# Set no attachment force
func _ready():
	._ready()
	is_flippable = false
	is_centered = true
	attached_player.attachment_force_active = false

# Fire
func fire_weapon():
	if can_spawn:
		can_spawn = false
		Audio.sfx_mine_arm()
		spawn_mine()
		$CooldownTimer.start()


# Cool
func cool_weapon():
	pass


# Spawn a rocket
func spawn_mine():
	var mine_instance = mine.instance()
	mine_instance.is_flipped = is_flipped
	Globals.spawn_ammo(mine_instance, $SpawnPosition.global_position)


# Can continue spawning
func _on_CooldownTimer_timeout():
	can_spawn = true
