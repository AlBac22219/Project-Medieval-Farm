extends Control

@export var grid_cont: GridContainer
@export var player_texture_node: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_update.connect(_on_inventory_update)
	_on_inventory_update()

func _input(event):
	if event.is_action_pressed("inventory_button"):
		get_parent().visible = !get_parent().visible
		get_tree().paused = !get_tree().paused
		open_inventory()

func _on_inventory_update():
	clear_grid_conteiner()
	for item in Global.inventory:
		var slot = Global.inventory_slot_scene.instantiate()
		if item != null:
			slot.set_item(item, false)
		else:
			slot.set_empty()
		grid_cont.add_child(slot)

func clear_grid_conteiner():
	while grid_cont.get_child_count() > 0:
		var child = grid_cont.get_child(0)
		grid_cont.remove_child(child)
		child.queue_free()

func open_inventory():
	for i in get_parent().get_parent().get_child(0).get_child_count():
		player_texture_node.get_child(i).texture = get_parent().get_parent().get_child(0).get_child(i).texture
		player_texture_node.get_child(i).material = get_parent().get_parent().get_child(0).get_child(i).material
