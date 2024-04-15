extends Resource

class_name Inventory

signal update_inventory
@export var slots: Array[InventorySlot]

func insert_item(item: InventoryItem, quantity_of_item: int):
	for slot in slots:
		if slot.item == item:
			if slot.item["max_quantity"] >= slot.quantity + quantity_of_item:
				slot.quantity += quantity_of_item
				update_inventory.emit()
				return
			else:
				var difference_between_quantities = slot.item["max_quantity"] - slot.quantity
				if difference_between_quantities > 0:
					if slot.item["max_quantity"] >= slot.quantity + difference_between_quantities:
						slot.quantity += difference_between_quantities
						quantity_of_item -= difference_between_quantities
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].quantity = quantity_of_item
			update_inventory.emit()
			return

func have_free_space():
	for i in slots:
		if !i.item:
			return true
	return false
