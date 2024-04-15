extends Control

@export var grid_cont: GridContainer
@export var player_texture_node: Control
@export var inventory: Inventory
var slots

# Called when the node enters the scene tree for the first time.
func _ready():
	create_inventory(inventory.slots.size())
	inventory.connect("update_inventory", update)
	update()

func _input(event):
	if event.is_action_pressed("inventory_button"):
		get_parent().visible = !get_parent().visible
		get_tree().paused = !get_tree().paused
		open_inventory()

func open_inventory():
	for i in get_parent().get_parent().get_child(0).get_child_count():
		player_texture_node.get_child(i).texture = get_parent().get_parent().get_child(0).get_child(i).texture
		player_texture_node.get_child(i).material = get_parent().get_parent().get_child(0).get_child(i).material

func create_inventory(inventory_size: int):
	for i in range(inventory_size):
		var slot_scene = preload("res://src/UI/Inventory/inventory_slot.tscn")
		var slot_inst = slot_scene.instantiate()
		grid_cont.add_child(slot_inst)
	slots = grid_cont.get_children()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

