extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(1.5, 1.5), 0.2)
	$Tween.interpolate_property(self, "modulate", modulate, Color(0, 0, 0, 0.5), 0.2)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
