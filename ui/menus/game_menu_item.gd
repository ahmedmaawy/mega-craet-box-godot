extends Node2D

export var menu_text : String = ""
export var menu_id : int = 0
export var is_active: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = menu_text
	if not is_active:
		$ColorRect.visible = false


# Is it active?
func set_active(activated):
	$ColorRect.visible = activated
