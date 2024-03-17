extends KinematicBody2D

# Properties
export (int) var speed = 0
export (int) var gravity = 4000
export (bool) var is_fire = false
export (int) var health_guage = 100
export (Globals.EnemyKind) var enemy_kind

# Variables
var velocity = Vector2.ZERO
var is_flipped = false
var horizontal_speed = 0

onready var animated_sprite = $AnimatedSprite


# Enemy killed
func kill_enemy():
	queue_free()


# Reduce the health of the enemy
func reduce_health(amount, ammo_horizontal_speed, vertical_force, impulse_force):
	health_guage -= amount
	
	if health_guage <= 0:
		Globals.kill_enemy(enemy_kind, 
			position, ammo_horizontal_speed, impulse_force, vertical_force,
			is_flipped)
		kill_enemy()
	else:
		animated_sprite.modulate = Color(1, 0, 0, 0.6)
		$CooldownTimer.start()

# Movement
func _physics_process(delta):
	if $LeftCast.is_colliding() and is_flipped:
		is_flipped = false
	
	if $RightCast.is_colliding() and not is_flipped:
		is_flipped = true
		
	if is_flipped:
		if is_on_floor():
			velocity.x = speed * -1
		else:
			if velocity.x > 0:
				velocity.x -= speed
			
		animated_sprite.flip_h = true
	else:
		if is_on_floor():
			velocity.x = speed
		else:
			if velocity.x < 0:
				velocity.x += speed
		
		animated_sprite.flip_h = false
	
	if $LeftCast.is_colliding():
		is_flipped = false
	
	horizontal_speed = velocity.x
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


# Return back
func _on_CooldownTimer_timeout():
	if not is_fire:
		animated_sprite.modulate = Color(1, 1, 1, 1)
	else:
		animated_sprite.modulate = Color(1, 0, 0, 1)
