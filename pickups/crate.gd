extends RigidBody2D

signal crate_picked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# When the crate body enters
func _on_Trigger_body_entered(body):
	if Globals.is_crate_pickable:
		if body.is_in_group("player"):
			Globals.is_crate_pickable = false
			$CooldownTimer.start()
			
			Audio.sfx_play_crate()
			
			visible = false
			emit_signal("crate_picked")
			Globals.crate_picked()
			
			# Disable trigger / collider
			$Trigger/CollisionShape2D.set_deferred("disabled", true)


# Enable the collider / trigger
func enable_collider():
	$Trigger/CollisionShape2D.set_deferred("disabled", false)


# Restore pickable crate
func _on_CooldownTimer_timeout():
	Globals.is_crate_pickable = true
