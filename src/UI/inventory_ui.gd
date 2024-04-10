extends Control

@export var grid_cont: GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_update.connect(_on_inventory_update)
	_on_inventory_update()

func _input(event):
	if event.is_action_pressed("inventory_button"):
		get_parent().visible = !get_parent().visible
		get_tree().paused = !get_tree().paused

func _on_inventory_update():
	clear_grid_conteiner()

func clear_grid_conteiner():
	while grid_cont.get_child_count() > 0:
		var child = grid_cont.get_child(0)
		grid_cont.remove_child(child)
		child.queue_free()
