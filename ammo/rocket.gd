extends Area2D

export (bool) var is_flipped = false
export (int) var speed = 1000
export (int) var damage = 100
export (float) var impulse_force = 1
export (int) var vertical_force = -1000

var horizontal_speed = 0
var is_moving = true

const smoke_animation = preload("res://fx/smoke.tscn")
var affected_bodies = []


# Called when the node enters the scene tree for the first time.
func _ready():
	is_moving = true
	if is_flipped:
		$Sprite.flip_h = true
		$SmokePosition.position.x *= -1
	
	$SmokeTimer.start()


# Body entered - add it to affected bodies
func _on_Radius_body_entered(body):
	affected_bodies.append(body)


# Body exited - remove it from affected bodies
func _on_Radius_body_exited(body):
	affected_bodies.erase(body)


# Pass
func _process(delta):
	if is_moving:
		if is_flipped:
			horizontal_speed = speed * -1
			position -= Vector2(speed, 0) * delta
		else:
			horizontal_speed = speed
			position += Vector2(speed, 0) * delta


# Spawn some smoke
func spawn_smoke(smoke_scale = Vector2(1, 1)):
	var smoke_instance = smoke_animation.instance()
	smoke_instance.scale = smoke_scale
	Globals.spawn_ammo(smoke_instance, $SmokePosition.global_position)


# When timing out
func _on_SmokeTimer_timeout():
	spawn_smoke()


# When an enemy is hit
func _on_Rocket_body_entered(body):
	body.reduce_health(damage, horizontal_speed, vertical_force, impulse_force)
	$SmokeTimer.stop()
	
	# Explode
	Audio.sfx_play_grenade()
	Globals.do_screen_shake(0.6)
	
	# Any bodies in the vicinity?
	for body_instance in affected_bodies:
		if body_instance != body:
			if body_instance.is_in_group("enemy"):
				body_instance.reduce_health(damage, 0, vertical_force, impulse_force)
			elif body_instance.is_in_group("player"):
				body_instance.kill_player(position)
	
	$Sprite.hide()
	$Explosion.show()
	
	is_moving = false
	
	$Tween.interpolate_property($Explosion, "scale", Vector2(1, 1), Vector2(2, 2), 0.2)
	$Tween.interpolate_property($Explosion, "modulate", $Explosion.modulate, Color(1, 1, 1, 1), 0.2)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	$Tween.interpolate_property($Explosion, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	queue_free()


# Delete the object once it leaves the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
