extends Node2D

var is_flipped = false
signal spawn_ammo(position)
var attached_player = null
export (bool) var is_flippable = true
export (bool) var is_centered = false


# When the node enters the scene for the first time
func _ready():
	# Activate can kill by default
	attached_player.can_kill = true
	
	# Flip checks
	if is_flipped != attached_player.is_inverted:
		is_flipped = attached_player.is_inverted
	
		if is_flipped:
			flip_weapon()


# Get texture base
func get_texture_base():
	if has_node("Texture"):
		return $Texture.texture
	else:
		return null


# Flip the weapon
func flip_weapon():
	if has_node("Texture"):
		$Texture.flip_h = !$Texture.flip_h
	
	if has_node("SpawnPosition"):
		$SpawnPosition.position.x *= -1
	
	is_flipped = not is_flipped


# Button was pressed
func _input(event):
	if not Globals.is_player_killed:
		if event.is_action_pressed("shoot"):
			if has_method("fire_weapon"):
				call("fire_weapon")
		elif event.is_action_released("shoot"):
			if has_method("cool_weapon"):
				call("cool_weapon")
