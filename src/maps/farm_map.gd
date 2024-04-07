extends Node2D

@export var tilemap: TileMap
var dict_with_plants = {}
const max_stage = 2
const max_life_cycle = 8


func grow_plants():
	for i in dict_with_plants.keys():
		if dict_with_plants[i][1]<max_stage:
			tilemap.set_cell(2, i, 2, Vector2i(dict_with_plants[i][1]+1,0))
		if dict_with_plants[i][1] > max_life_cycle:
			#tilemap.set_cell(2, i, 1, Vector2i(11,0))
			tilemap.erase_cell(2, i)
			dict_with_plants.erase(i)
		else:
			dict_with_plants[i][1] +=1

func add_to_dict_with_plants(coords: Vector2i, name_of_plants: String, stage: int):
	dict_with_plants[coords] = [name_of_plants, stage]
