extends Node2D

@export var tilemap: TileMap
@export var day_night_canvas: CanvasModulate
@export var canvas_layer: CanvasLayer
@export var time_ui: Control
@export var player: CharacterBody2D
@export var plant: PackedScene

var dict_with_plants = {}
const max_stage = 2
const max_life_cycle = 8

func _ready():
	canvas_layer.visible = true
	day_night_canvas.time_tick.connect(time_ui.set_day_time)
	player.set_can_work(true)
	var wheat_drop = plant.instantiate()
	wheat_drop.global_position = $Marker2D.global_position
	wheat_drop.item_type = preload("res://src/items/wheat.tres")
	add_child(wheat_drop)

func grow_plants():
	for i in dict_with_plants.keys():
		if dict_with_plants[i][1]<max_stage:
			tilemap.set_cell(2, i, 2, Vector2i(dict_with_plants[i][1]+1,0))
		if dict_with_plants[i][1] >= max_life_cycle:
			tilemap.erase_cell(2, i)
			dict_with_plants.erase(i)
		else:
			dict_with_plants[i][1] +=1

func add_to_dict_with_plants(coords: Vector2i, name_of_plants: String, stage: int):
	dict_with_plants[coords] = [name_of_plants, stage]


func _on_day_night_mode_new_day():
	grow_plants()
