extends Area2D

export var start_frame: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.frame = start_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Fire entred
func _on_Fire_body_entered(body):
	Globals.fire_body_entered(body)
