extends RigidBody2D

export var impulse : Vector2 = Vector2(-400, -240)
export var enemy_position = Vector2(0, 0)
export var is_testing : bool = false
export var torque : int = 1
export var flipped : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_testing:
		push(position + enemy_position)
	
	if flipped:
		$Sprite.flip_h = true


# Test impulse
func push(position: Vector2):
	angular_velocity = torque
	apply_impulse(position, impulse)


# Delete when it leaves the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
