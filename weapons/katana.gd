extends "res://weapons/weapon_base.gd"

export (int) var damage = 100
export (float) var impulse_force = 0.5
export (int) var vertical_force = -500

var horizontal_speed = 0

var affected_bodies_front = []
var affected_bodies_back = []


# Set no attachment force
func _ready():
	._ready()
	attached_player.attachment_force_active = false


# Kill bodies attached to the katana
func kill_bodies(bodies):
	for body in bodies:
		if body.is_in_group("enemy"):
			body.reduce_health(damage, 0, vertical_force, impulse_force)


# Fire
func fire_weapon():
	# Deactivate kill
	attached_player.can_kill = false
	
	var angle_to_rotate = 90
	
	if is_flipped:
		angle_to_rotate = -90
	
	# Move the weapon down
	$Tween.interpolate_property($Sprite, "rotation_degrees", 0, angle_to_rotate, 0.05)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	# Katana SFX
	Audio.sfx_katana_hit()
	
	# Kill enemies facing the correct side
	if is_flipped:
		kill_bodies(affected_bodies_back)
	else:
		kill_bodies(affected_bodies_front)
	
	# Move the weapon up
	$Tween.interpolate_property($Sprite, "rotation_degrees", angle_to_rotate, 0, 0.05)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	# Reactivate kill
	attached_player.can_kill = true


# Cool
func cool_weapon():
	pass


# Back area entered
func _on_AreaBack_body_entered(body):
	affected_bodies_back.append(body)


# Back area exit
func _on_AreaBack_body_exited(body):
	affected_bodies_back.erase(body)


# Front area entered
func _on_AreaFront_body_entered(body):
	affected_bodies_front.append(body)


# Front area exit
func _on_AreaFront_body_exited(body):
	affected_bodies_front.erase(body)
