extends Control

signal get_slot(slot)
@export var h_box_container: HBoxContainer
@export var inventory: Inventory
var slots
var old_selected_sprite = null
var new_selected_sprite = null
# Called when the node enters the scene tree for the first time.
func _ready():
	create_inventory(10)
	inventory.connect("update_inventory", update)
	update()

func create_inventory(inventory_size: int):
	for i in range(inventory_size):
		var slot_scene = preload("res://src/UI/Inventory/inventory_slot.tscn")
		var slot_inst = slot_scene.instantiate()
		slot_inst.set_in_game(true)
		slot_inst.id = i
		h_box_container.add_child(slot_inst)
	slots = h_box_container.get_children()
	connect_update_signals()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _input(event):
	if event.is_action_pressed("1_slot"):
		emit_signal("get_slot", inventory.slots[0])
		change_selection(0)
	elif event.is_action_pressed("2_slot"):
		emit_signal("get_slot", inventory.slots[1])
		change_selection(1)
	elif event.is_action_pressed("3_slot"):
		emit_signal("get_slot", inventory.slots[2])
		change_selection(2)
	elif event.is_action_pressed("4_slot"):
		emit_signal("get_slot", inventory.slots[3])
		change_selection(3)
	elif event.is_action_pressed("5_slot"):
		emit_signal("get_slot", inventory.slots[4])
		change_selection(4)
	elif event.is_action_pressed("6_slot"):
		emit_signal("get_slot", inventory.slots[5])
		change_selection(5)
	elif event.is_action_pressed("7_slot"):
		emit_signal("get_slot", inventory.slots[6])
		change_selection(6)
	elif event.is_action_pressed("8_slot"):
		emit_signal("get_slot", inventory.slots[7])
		change_selection(7)
	elif event.is_action_pressed("9_slot"):
		emit_signal("get_slot", inventory.slots[8])
		change_selection(8)
	elif event.is_action_pressed("0_slot"):
		emit_signal("get_slot", inventory.slots[9])
		change_selection(9)

func change_selection(slot_id: int):
	old_selected_sprite = new_selected_sprite
	new_selected_sprite = slots[slot_id]
	if old_selected_sprite:
		old_selected_sprite.select(false)
		new_selected_sprite.select(true)
	else:
		new_selected_sprite.select(true)

func update_selected_slot(id_of_slot: int):
	emit_signal("get_slot", inventory.slots[id_of_slot])

func connect_update_signals():
	for slot in slots:
		slot.connect("update_item", update_selected_slot)
