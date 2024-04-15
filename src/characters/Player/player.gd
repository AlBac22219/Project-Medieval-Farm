extends CharacterBody2D

@export var anim_player: AnimationPlayer
@export var inventory_ui: CanvasLayer
@export var inventory: Inventory
@export var plant_seed: InventorySlot
const SPEED = 30.0
const ACCELERATION = 200.0
enum walk_states {WALK_LEFT, WALK_RIGHT, WALK_DOWN, WALK_UP}
enum work_modes {DIG, FIGHT, RIDGE, FARM, COLLECT}
var last_state = walk_states.WALK_DOWN
var work_mode = work_modes.FARM
var in_work_area = false
var can_work = false
var areas_array = []

func _ready():
	pass

func _physics_process(delta):
	var direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	direction = direction.normalized()
	set_animation(direction)
	velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
	velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
	move_and_slide()

func _input(event):
	if event.is_action_pressed("left_click"):
		if in_work_area and can_work:
			var id_of_tiles = 0
			var founded_tileMap = false
			for i in get_parent().get_children():
				if i.is_class("TileMap"):
					founded_tileMap = true
					break
				else:
					id_of_tiles+=1
			if founded_tileMap:
				var tilemap: TileMap = get_parent().get_child(id_of_tiles)
				match work_mode:
					work_modes.DIG:
						dig(tilemap)
					work_modes.RIDGE:
						ridge(tilemap)
					work_modes.FARM:
						farm(tilemap)
		match work_mode:
			work_modes.FIGHT:
				pass
			work_modes.COLLECT:
				var id_of_tiles = 0
				var founded_tileMap = false
				for i in get_parent().get_children():
					if i.is_class("TileMap"):
						founded_tileMap = true
						break
					else:
						id_of_tiles+=1
				if founded_tileMap:
					var tilemap: TileMap = get_parent().get_child(id_of_tiles)
					harvest(tilemap)

func set_can_work(is_can_work: bool):
	can_work = is_can_work

func set_animation(direction):
	if direction.x > 0:
		anim_player.play("walk_right")
		last_state = walk_states.WALK_RIGHT
	elif direction.x < 0:
		anim_player.play("walk_left")
		last_state = walk_states.WALK_LEFT
	elif direction.y > 0:
		anim_player.play("walk_down")
		last_state = walk_states.WALK_DOWN
	elif direction.y < 0:
		anim_player.play("walk_up")
		last_state = walk_states.WALK_UP
	else:
		match last_state:
			walk_states.WALK_LEFT:
				anim_player.play("stand_left")
			walk_states.WALK_RIGHT:
				anim_player.play("stand_right")
			walk_states.WALK_DOWN:
				anim_player.play("stand_down")
			walk_states.WALK_UP:
				anim_player.play("stand_up")

func _on_area_for_work_mouse_entered():
	in_work_area = true

func _on_area_for_work_mouse_exited():
	in_work_area = false

func dig(tilemap: TileMap):
	var tile_data: TileData = tilemap.get_cell_tile_data(1, tilemap.local_to_map(get_global_mouse_position()))
	if tile_data:
		var can_dig_up = tile_data.get_custom_data("can_be_dig_up")
		if can_dig_up:
			var dirt_tiles = []
			dirt_tiles.append(tilemap.local_to_map(get_global_mouse_position()))
			tilemap.set_cells_terrain_connect(1, dirt_tiles, 0, 0)

func ridge(tilemap: TileMap):
	var tile_data: TileData = tilemap.get_cell_tile_data(1, tilemap.local_to_map(get_global_mouse_position()))
	if tile_data:
		var can_be_ridge = tile_data.get_custom_data("can_be_ridge")
		if can_be_ridge:
			tilemap.set_cell(1, tilemap.local_to_map(get_global_mouse_position()), 1, Vector2i(10,0))

func farm(tilemap: TileMap):
	var ground_tile_data: TileData = tilemap.get_cell_tile_data(1, tilemap.local_to_map(get_global_mouse_position()))
	if ground_tile_data:
		var can_be_farmed = ground_tile_data.get_custom_data("can_be_farmed")
		var have_we_plant = tilemap.get_cell_tile_data(2, tilemap.local_to_map(get_global_mouse_position()))
		if not have_we_plant:
			if can_be_farmed && plant_seed.item != null:
				plant_seed.quantity -= 1
				tilemap.set_cell(2, tilemap.local_to_map(get_global_mouse_position()), 2, plant_seed.item.tileset_coord)
				get_parent().add_to_dict_with_plants(tilemap.local_to_map(get_global_mouse_position()), plant_seed.item.name, 0)
				if plant_seed.quantity < 1:
					plant_seed.item = null
				inventory.update_inventory.emit()

func harvest(tilemap: TileMap):
	var harvest_tile_data: TileData = tilemap.get_cell_tile_data(2, tilemap.local_to_map(get_global_mouse_position()))
	if harvest_tile_data:
		var can_be_harvest = harvest_tile_data.get_custom_data("can_be_harvest")
		if can_be_harvest:
			var path_of_plant = harvest_tile_data.get_custom_data("plant_path")
			var path_to_scene = harvest_tile_data.get_custom_data("path_to_scene")
			var plant_scene: PackedScene = load(path_to_scene)
			var plant =  plant_scene.instantiate()
			plant.global_position = get_global_mouse_position()
			plant.item_type = load(path_of_plant)
			plant.set_quantity(randi_range(2,6))
			get_parent().add_child(plant)
			tilemap.erase_cell(2, tilemap.local_to_map(get_global_mouse_position()))

func _on_in_game_inventory_ui_get_slot(slot: InventorySlot):
	if slot.item:
		if slot.item["type"] == "Семена":
			plant_seed = slot
			work_mode = slot.item["work_mode"]
		elif slot.item["type"] == "Инструмент":
			plant_seed = null
			work_mode = slot.item["work_mode"]
