extends Panel

@export var item_sprite: Sprite2D
@export var quantity: Label

func update(slot: InventorySlot):
	if !slot.item:
		item_sprite.texture = null
		quantity.text = ""
	else:
		item_sprite.texture = slot.item["texture"]
		if slot.quantity > 1:
			quantity.text = str(slot.quantity)
		else:
			quantity.text = ""
		
