extends Control

signal username_set(username, username_with_uuid)


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/UserNameEdit.grab_focus()


# Saves user name
func save_username():
	var username = $VBoxContainer/UserNameEdit.text.strip_edges()
	var username_uuid = Globals.util.v4()
	username_uuid = username_uuid.replace("-", "_")
	var username_with_uuid = username + '_' + username_uuid
	
	if username != "":
		Globals.set_username(username, username_with_uuid)
		emit_signal("username_set", username, username_with_uuid)
		queue_free()


# Button
func _on_Button_pressed():
	save_username()


# Enter pressed
func _on_UserNameEdit_text_entered(new_text):
	save_username()
