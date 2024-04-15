extends Button
signal my_pressed
signal update_item(inventory_slot_id)
@export var background_sprite: Sprite2D
@export var item_sprite: Sprite2D
@export var quantity: Label
@export var selected: bool = false
@export var in_game: bool = false
var id: int

func _ready():
	if selected:
		background_sprite.frame = 1

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
		if selected:
			update_item.emit(id)

func select(new_select):
	selected = new_select
	if selected:
		background_sprite.frame = 0
	else:
		background_sprite.frame = 1

func set_in_game(is_in_game: bool):
	in_game = is_in_game

func _on_pressed():
	if !in_game:
		print("press")
		emit_signal("my_pressed")
