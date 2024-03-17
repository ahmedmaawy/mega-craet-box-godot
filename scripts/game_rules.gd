extends Node

signal level_unlocked(level)
signal weapon_unlocked(weapon)

export (bool) var is_test_mode = false
# Test Mode
export (int) var test_mode_level2_unlock = 3
export (int) var test_mode_level3_unlock = 3
# Production Mode
export (int) var level2_unlock = 15
export (int) var level3_unlock = 20

const test_weapon_unlocks = {
	2: Globals.GameWeapon.DUAL_PISTOL,
	4: Globals.GameWeapon.DISK_GUN,
	6: Globals.GameWeapon.BAZOOKA,
	8: Globals.GameWeapon.GRANADE_LAUNCHER,
}

const weapon_unlocks = {
	30: Globals.GameWeapon.DUAL_PISTOL,
	60: Globals.GameWeapon.DISK_GUN,
	90: Globals.GameWeapon.BAZOOKA,
	120: Globals.GameWeapon.GRANADE_LAUNCHER,
	150: Globals.GameWeapon.KATANA,
	180: Globals.GameWeapon.MINES,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("crate_picked", self, "_on_crate_picked")


# Do a weapon unlock
func unlock_weapon(total_crates, weapon_unlocks):
	if int(total_crates) in weapon_unlocks:
		var weapon_id = weapon_unlocks[total_crates]
		var weapon = Globals.GameWeapon.keys()[weapon_id]
		Globals.set_weapon_enabled(weapon, true)
		Globals.enabled_weapons.append(weapon)
		emit_signal("weapon_unlocked", weapon)


# Unlock a level
func unlock_level(level_number):
	if not Globals.get_level_enabled(level_number):
		Globals.set_level_enabled(level_number, true)
		emit_signal("level_unlocked", level_number)


# Tally the crates picked against level
func crate_pick(total_crates, level_crates, level):
	match int(level):
		1:
			if is_test_mode:
				if level_crates >= test_mode_level2_unlock:
					unlock_level(2)
			else:
				if level_crates >= level2_unlock:
					unlock_level(2)
		2:
			if is_test_mode:
				if level_crates >= test_mode_level3_unlock:
					unlock_level(3)
			else:
				if level_crates >= level3_unlock:
					unlock_level(3)
	
	if is_test_mode:
		unlock_weapon(total_crates, test_weapon_unlocks)
	else:
		unlock_weapon(total_crates, weapon_unlocks)
	
	# Persist the number of crates
	Globals.set_num_crates(total_crates)


# When crate is picked
func _on_crate_picked(is_initialization):
	if not is_initialization:
		Globals.num_crates += 1
		Globals.current_level_num_crates += 1
		
		var current_stage = Globals.current_stage
		var current_level_crates = Globals.current_level_num_crates
		var current_total_crates = Globals.num_crates
		
		crate_pick(current_total_crates, current_level_crates, current_stage)
