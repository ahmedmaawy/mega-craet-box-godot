extends Node2D

# Signals
signal item_selected(item_index)

# Exports
export (Array, String) var menu_items = []
export (int) var menu_height = 100
export (int) var active_index = 0
export (bool) var is_enabled = true

# Variables
var menu_item_scene = preload("res://ui/menus/game_menu_item.tscn")
var menu_item_controls = []
var num_menu_items = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var menu_index = 0
	
	# Build the menu
	for menu_item in menu_items:
		var menu_item_control = menu_item_scene.instance()
		
		menu_item_control.menu_text = menu_item
		menu_item_control.menu_id = menu_index
		menu_item_control.position.y = menu_index * menu_height
		menu_item_control.is_active = (menu_index == active_index)
		
		call_deferred("add_child", menu_item_control)
		
		menu_item_controls.append(menu_item_control)
		menu_index += 1
	
	num_menu_items = menu_item_controls.size()


# Input events
func _input(event):
	if is_enabled:
		if event.is_action_pressed("ui_up"):
			if active_index > 0:
				menu_item_controls[active_index].set_active(false)
				active_index -= 1
				Audio.sfx_play_menu()
		elif event.is_action_pressed("ui_down"):
			if active_index < (num_menu_items - 1):
				menu_item_controls[active_index].set_active(false)
				active_index += 1
				Audio.sfx_play_menu()
		elif event.is_action_pressed("ui_accept"):
			emit_signal("item_selected", active_index)
		
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			menu_item_controls[active_index].set_active(true)


# Toggle visibility
func set_control_visible(visibility):
	for control_item in menu_item_controls:
		control_item.visible = visibility
	
	if visibility:
		show()
	else:
		hide()
