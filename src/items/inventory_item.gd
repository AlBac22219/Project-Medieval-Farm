extends CharacterBody2D

const SPEED = 1800.0
const ACCELERATION = 300.0
@export var icon_sprite: Sprite2D
@export var item_type: InventoryItem
@export var quantity: int = 0

var player = null
var player_in_range = false
var can_be_pickable: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	icon_sprite.texture = item_type.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_range && can_be_pickable:
		if Global.have_free_space_in_inventory():
			var direction = Vector2(player.global_position.x - global_position.x, player.global_position.y - global_position.y)
			direction = direction.normalized()
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
			velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
			if global_position.distance_to(player.global_position) < 16:
				pickup_item(player.inventory)
			move_and_slide()

func pickup_item(inventory: Inventory):
	var inventory_slot: InventorySlot
	#inventory_slot.item = item_type
	#inventory_slot.quantity = quantity
	inventory.insert_item(item_type)
	queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		player_in_range = true
		player = area.get_parent()
		can_be_pickable = player.inventory.have_free_space()

func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("Player"):
		player_in_range = false
		player = null
		can_be_pickable = false

