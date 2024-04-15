extends Resource

class_name InventoryItem
enum work_modes {DIG, FIGHT, RIDGE, FARM, COLLECT}
@export var texture: Texture2D
@export var name: String
@export var type: String
@export var description: String
@export var max_quantity: int
@export var tileset_coord: Vector2i
@export var work_mode: work_modes
@export var optimal_price: float
