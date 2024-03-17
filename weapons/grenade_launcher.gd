extends "res://weapons/weapon_base.gd"

const grenade = preload("res://ammo/grenade.tscn")

var can_spawn = true


# Set no attachment force
func _ready():
	._ready()
	can_spawn = true
	attached_player.attachment_force_active = false


# Fire
func fire_weapon():
	if can_spawn:
		spawn_grenade()
		can_spawn = false
		$CooldownTimer.start()


# Cool
func cool_weapon():
	pass


# Spawn a rocket
func spawn_grenade():
	Audio.sfx_play_bullet()
	var grenade_instance = grenade.instance()
	grenade_instance.is_flipped = is_flipped
	Globals.spawn_ammo(grenade_instance, $SpawnPosition.global_position)


# Can spawn
func _on_CooldownTimer_timeout():
	can_spawn = true
