extends Node2D

export (String) var message_to_show = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.text = message_to_show
	$AnimationPlayer.play("MessageFader")


# Kill the message view after the animation is over
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
