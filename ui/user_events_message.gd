extends Node2D

# Props
export (String) var message_to_show = ""

# Vars
onready var message_control = $CenterContainer/Message


# Called when the node enters the scene tree for the first time.
func _ready():
	message_control.text = message_to_show
	$AnimationPlayer.play("MessageFader")


# Kill the object after the animation is over
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
