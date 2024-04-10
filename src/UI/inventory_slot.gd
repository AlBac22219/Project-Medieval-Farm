extends Control

var mouse_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_outer_border_mouse_entered():
	mouse_inside = !mouse_inside

func _on_outer_border_mouse_exited():
	mouse_inside = !mouse_inside

func _input(event):
	if event.is_action_pressed("left_click"):
		pass
	elif event.is_action_pressed("right_click"):
		pass
