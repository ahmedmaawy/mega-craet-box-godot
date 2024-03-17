extends "res://weapons/weapon_base.gd"

const rocket = preload("res://ammo/rocket.tscn")

var can_spawn = true


# Set no attachment force
func _ready():
	._ready()
	can_spawn = true
	attached_player.attachment_force_active = false

# Fire
func fire_weapon():
	if can_spawn:
		Audio.sfx_play_bazooka()
		can_spawn = false
		spawn_rocket()
		$CooldownTimer.start()


# Cool
func cool_weapon():
	pass


# Spawn a rocket
func spawn_rocket():
	var rocket_instance = rocket.instance()
	rocket_instance.is_flipped = is_flipped
	Globals.spawn_ammo(rocket_instance, $SpawnPosition.global_position)


# Can spawn
func _on_CooldownTimer_timeout():
	can_spawn = true
