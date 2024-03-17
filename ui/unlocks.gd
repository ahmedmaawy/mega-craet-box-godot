extends Node2D

signal unlocks_done

const enabled_text = "Enabled"
const disabled_text = "Disabled"

onready var dual_pistols_label = $Container/Row_1/LeftRect/Enabled
onready var disk_gun_label = $Container/Row_1/RightRect/Enabled
onready var bazooka_label = $Container/Row_2/LeftRect/Enabled
onready var grenade_launcher_label = $Container/Row_2/RightRect/Enabled
onready var katana_label = $Container/Row_3/LeftRect/Enabled
onready var mines_label = $Container/Row_3/RightRect/Enabled


# Called when the node enters the scene tree for the first time.
func _ready():
	# Dual Pistols
	if Globals.get_weapon_enabled(get_weapon_index(Globals.GameWeapon.DUAL_PISTOL)):
		dual_pistols_label.text = enabled_text
	else:
		dual_pistols_label.text = disabled_text
	
	# Disk Gun
	if Globals.get_weapon_enabled(get_weapon_index(Globals.GameWeapon.DISK_GUN)):
		disk_gun_label.text = enabled_text
	else:
		disk_gun_label.text = disabled_text
	
	# Bazooka
	if Globals.get_weapon_enabled(get_weapon_index(Globals.GameWeapon.BAZOOKA)):
		bazooka_label.text = enabled_text
	else:
		bazooka_label.text = disabled_text
	
	# Grenade Launcher
	if Globals.get_weapon_enabled(get_weapon_index(Globals.GameWeapon.GRANADE_LAUNCHER)):
		grenade_launcher_label.text = enabled_text
	else:
		grenade_launcher_label.text = disabled_text
	
	# Katana
	if Globals.get_weapon_enabled(get_weapon_index(Globals.GameWeapon.KATANA)):
		katana_label.text = enabled_text
	else:
		katana_label.text = disabled_text
	
	# Mines
	if Globals.get_weapon_enabled(get_weapon_index(Globals.GameWeapon.MINES)):
		mines_label.text = enabled_text
	else:
		mines_label.text = disabled_text


# Get index of weapon from key
func get_weapon_index(key):
	return Globals.GameWeapon.keys()[key]


# Input handling
func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		emit_signal("unlocks_done")
		queue_free()
