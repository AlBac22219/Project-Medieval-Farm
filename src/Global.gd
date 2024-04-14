extends Node

signal inventory_update
@onready var inventory_slot_scene = preload("res://src/UI/Inventory/inventory_slot.tscn")
var player_inventory_grid_container: GridContainer

var inventory = []
var player_node: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.resize(20)

func add_item(item):
	pass

func have_free_space_in_inventory() -> bool:
	for i in range(inventory.size()):
		if inventory[i] == null:
			return true
	return false

func remove_item():
	inventory_update.emit()

func change_inventory_size():
	inventory_update.emit()

func set_player_node(player):
	player_node = player
