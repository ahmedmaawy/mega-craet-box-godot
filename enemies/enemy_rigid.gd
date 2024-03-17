extends RigidBody2D

export (int) var horizontal_speed = 0
export (int) var impulse_force = 0
export (bool) var is_testing : bool = false
export (int) var torque = 1
export (int) var flipped = false
export (Globals.EnemyKind) var enemy_kind = null
export (int) var upward_thrust = -300

var current_sprite = null


# Called when the node enters the scene tree for the first time.
func _ready():
	match enemy_kind:
		Globals.EnemyKind.BIRD:
			current_sprite = $BirdSprite
		Globals.EnemyKind.GOBLIN:
			current_sprite = $GoblinSprite
		Globals.EnemyKind.GOBLIN_SMALL:
			current_sprite = $GoblinSmallSprite
	
	current_sprite.show()
	
	if not is_testing:
		push()
	
	if flipped:
		current_sprite.flip_h = true


# Test impulse
func push():
	angular_velocity = torque
	linear_velocity = Vector2(horizontal_speed * impulse_force, upward_thrust)


# Delete the object
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
