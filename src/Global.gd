extends Node

signal inventory_update

var inventory = []
var player_node: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.resize(10)

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_name"] == item["item_name"]:
			if (inventory[i]["quantity"] + item["quantity"]) <= inventory[i]["max_quantity"]:
				inventory[i]["quantity"] += item["quantity"]
				inventory_update.emit()
				return true
			elif inventory[i]["quantity"] < inventory[i]["max_quantity"]:
				var remains_of_item = inventory[i]["max_quantity"] - inventory[i]["quantity"]
				item["quantity"] = item["quantity"] - remains_of_item
				inventory[i]["quantity"] += remains_of_item
		elif inventory[i] == null:
			inventory[i] = item
			inventory_update.emit()
			return true
	
	return false

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
