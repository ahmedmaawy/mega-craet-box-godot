extends KinematicBody2D

# Signals
signal player_killed

# Variables
onready var animated_sprite = $AnimatedSprite
onready var weapons = $Weapons
onready var weapon_placeholders = $WeaponPlaceholders

# Exports
export (int) var speed = 600
export (int) var jump_speed = -1800
export (int) var gravity = 4000
export (bool) var is_inverted = false
export (int) var message_y_distance = -50
export (bool) var attachment_force_active = false
export (Vector2) var attachment_velocity = Vector2(0, 0)
export (bool) var can_kill = true

var velocity = Vector2.ZERO

# Player message
const player_message = preload("res://ui/user_events_message.tscn")

# Weapon Scenes
const weapon_scenes = {
	Globals.GameWeapon.BAZOOKA: preload("res://weapons/bazooka.tscn"),
	Globals.GameWeapon.DISK_GUN: preload("res://weapons/disk_gun.tscn"),
	Globals.GameWeapon.DUAL_PISTOL: preload("res://weapons/dual_pistols.tscn"),
	# Globals.GameWeapon.FLAME_THROWER: preload("res://weapons/flame_thrower.tscn"),
	Globals.GameWeapon.GRANADE_LAUNCHER : preload("res://weapons/grenade_launcher.tscn"),
	Globals.GameWeapon.KATANA: preload("res://weapons/katana.tscn"),
	# Globals.GameWeapon.LASER_GUN: preload("res://weapons/laser_gun.tscn"),
	Globals.GameWeapon.MACHINE_GUN: preload("res://weapons/machine_gun.tscn"),
	Globals.GameWeapon.MINES: preload("res://weapons/mines.tscn"),
	Globals.GameWeapon.PISTOL: preload("res://weapons/normal_gun.tscn"),
	Globals.GameWeapon.SHOTGUN: preload("res://weapons/shotgun.tscn"),
}

var current_weapon = null
var is_initializing = true


# Called when the node enters the scene tree for the first time.
func _ready():
	is_initializing = true
	animated_sprite.play("idle")
	Globals.connect("crate_picked", self, "_on_crate_picked")
	load_weapon('PISTOL')
	is_initializing = false


# Load a specific weapon to the scene
func load_weapon(weapon):
	if current_weapon != null:
		current_weapon.queue_free()
	
	current_weapon = weapon_scenes[Globals.GameWeapon[weapon]].instance()
	# Weapon placement
	var weapon_position = $WeaponPlaceholders/Front
	
	if is_inverted and current_weapon.is_flippable:
		weapon_position = $WeaponPlaceholders/Back
		current_weapon.flip_weapon()
	
	if current_weapon.is_centered:
		weapon_position = $WeaponPlaceholders/Center
	
	current_weapon.position = weapon_position.position
	current_weapon.attached_player = self
	
	# Only show message when not initializing
	if not is_initializing:
		# Spawn and display which weapon was selected
		var weapon_name = Globals.game_weapon_names[Globals.GameWeapon[weapon]]
		var player_message_instance = player_message.instance()
		player_message_instance.message_to_show = weapon_name
		
		Globals.spawn_object(player_message_instance, 
			global_position + Vector2(0, message_y_distance))
	
	# Add weapon to the player
	weapons.add_child(current_weapon)


# Flips the positions and directions of the weapons
func flip_weapons():
	for weapon in weapons.get_children():
		if weapon.is_flippable:
			weapon.position.x *= -1
			weapon.flip_weapon()


# Get Input
func get_input():
	velocity.x = 0
	
	if Input.is_action_pressed("ui_right"):
		if is_inverted:
			animated_sprite.flip_h = false
			flip_weapons()
			is_inverted = false
		
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		if not is_inverted:
			animated_sprite.flip_h = true
			flip_weapons()
			is_inverted = true
		
		velocity.x -= speed


# Player has been killed
func kill_player(enemy_position):
	if can_kill:
		# SFX
		Audio.sfx_play_jump()
		# Other functions
		Globals.kill_player(position, enemy_position, is_inverted)
		emit_signal("player_killed")
		queue_free()


# Physics Process
func _physics_process(delta):
	get_input()
	
	velocity.y += gravity * delta
	
	if attachment_force_active:
		var movement_velocity = attachment_velocity
		if is_inverted:
			movement_velocity.x *= -1
		
		velocity.x += movement_velocity.x
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Jump pressed
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			Audio.sfx_play_jump()
			velocity.y = jump_speed
	else:
		if is_inverted:
			if velocity.x < 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		else:
			if velocity.x > 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
	
	# Support for short & long jump press
	if Input.is_action_just_released("jump"):
		if not is_on_floor():
			# If jumping the y velocity < 0
			if velocity.y < 0:
				velocity.y = velocity.y / 2


# If a body enters the area
func _on_Trigger_body_entered(body):
	if body.is_in_group("enemy"):
		kill_player(body.position)


# When a crate is picked
func _on_crate_picked(is_initialization):
	if not is_initialization:
		var random_weapon = Globals.get_random_weapon()
		load_weapon(random_weapon)
