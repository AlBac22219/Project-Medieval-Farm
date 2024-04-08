@tool

extends CharacterBody2D


@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
@export var optimal_price:int = 0
const scene_path = "res://src/items/inventory_item.tscn"
const SPEED = 600.0
const ACCELERATION = 600.0
@export var icon_sprite: Sprite2D

var player = null
var player_in_range = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	if player_in_range:
		if Global.have_free_space_in_inventory():
			var direction = Vector2(player.global_position.x - global_position.x, player.global_position.y - global_position.y)
			direction = direction.normalized()
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
			velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
			if global_position.distance_to(player.global_position) < 6:
				pickup_item()
			move_and_slide()

func pickup_item():
	var item = {
		"quantity": 1,
		"item_type": item_type,
		"item_name": item_name,
		"item_texture": item_texture,
		"item_effect": item_effect,
		"optimal_price": optimal_price,
		"scene_path": scene_path
	}
	if Global.player_node:
		Global.add_item(item)
		self.queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		player_in_range = true
		player = area.get_parent()

func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("Player"):
		player_in_range = false
		player = null
