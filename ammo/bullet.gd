extends Area2D

export (bool) var is_flipped = false
export (int) var speed = 1000
export (int) var damage = 50
export (bool) var timed = false
export (int) var alive_time = 0.5
export (float) var impulse_force = 0.2
export (int) var vertical_force = -300

var horizontal_speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if timed:
		$AliveTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_flipped:
		horizontal_speed = speed * -1
		position -= Vector2(speed, 0).rotated(rotation) * delta
	else:
		horizontal_speed = speed
		position += Vector2(speed, 0).rotated(rotation) * delta


# It hit an enemy
func _on_Bullet_body_entered(body):
	body.reduce_health(damage, horizontal_speed, vertical_force, impulse_force)
	queue_free()


# Kill object if out of the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


# Delete the object if its alive
func _on_AliveTimer_timeout():
	queue_free()
