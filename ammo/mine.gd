extends RigidBody2D

export (bool) var is_flipped = false
export (int) var damage = 100
export (float) var impulse_force = 1.5
export (int) var vertical_force = -1000

var affected_bodies = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Should explode
func _on_Trigger_body_entered(body):
	Audio.sfx_play_grenade()
	Globals.do_screen_shake(0.5)
	
	for body in affected_bodies:
		if body.is_in_group("enemy"):
			body.reduce_health(damage, 0, vertical_force, impulse_force)
		elif body.is_in_group("player"):
			body.kill_player(position)
	
	# Explode
	$Sprite.hide()
	$Explosion.show()
	
	# Disable physics
	sleeping = true
	
	$Tween.interpolate_property($Explosion, "scale", Vector2(1, 1), Vector2(1.5, 1.5), 0.2)
	$Tween.interpolate_property($Explosion, "modulate", $Explosion.modulate, Color(1, 1, 1, 1), 0.2)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	$Tween.interpolate_property($Explosion, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	queue_free()


# Body entered - add it to affected bodies
func _on_Radius_body_entered(body):
	affected_bodies.append(body)


# Body exited - remove it from affected bodies
func _on_Radius_body_exited(body):
	affected_bodies.erase(body)
