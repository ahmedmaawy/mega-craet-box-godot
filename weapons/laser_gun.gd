extends "res://weapons/weapon_base.gd"


# Set no attachment force
func _ready():
	._ready()
	attached_player.attachment_force_active = false


# Fire
func fire_weapon():
	pass


# Cool
func cool_weapon():
	pass
