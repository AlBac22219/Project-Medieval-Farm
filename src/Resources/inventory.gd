extends Resource

class_name Inventory

signal update_inventory
@export var slots: Array[InventorySlot]

func insert_item(item: InventoryItem):
	for slot in slots:
		if slot.item == item:
			if slot.item["max_quantity"]>slot.quantity+1:
				slot.quantity +=1
				update_inventory.emit()
				return
	
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].quantity += 1
			update_inventory.emit()
			return

func have_free_space():
	for i in slots:
		if !i.item:
			return true
	return false
