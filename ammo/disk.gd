extends Area2D

export (bool) var is_flipped = false
export (int) var speed = 800
export (int) var vertical_force = -400
export (float) var impulse_force = 0.5
export (int) var damage = 100
export (int) var max_rounds = 2

var horizontal_speed = 0
var num_hits = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_flipped:
		horizontal_speed = speed * -1
		position -= Vector2(speed, 0) * delta
	else:
		horizontal_speed = speed
		position += Vector2(speed, 0) * delta


func _on_Disk_body_entered(body):
	if body.get_collision_layer() == 8:
		num_hits += 1
		
		if num_hits >= max_rounds:
			queue_free()
		
		is_flipped = not is_flipped
	elif body.is_in_group("enemy"):
		body.reduce_health(damage, horizontal_speed, vertical_force, impulse_force)
	elif body.is_in_group("player"):
		body.kill_player(position)
