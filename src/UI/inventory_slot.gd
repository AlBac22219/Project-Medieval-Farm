extends Control

@export var show_description_timer: Timer
@export var remove_panels_timer: Timer
@export var details_panel: Panel
@export var usage_panel: Panel
@export var icon: TextureRect
@export var quantity: Label
@export var item_name: Label
@export var item_type: Label
@export var item_description: Label
var mouse_inside: bool = false

var item = null
var slot_in_game:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_outer_border_mouse_entered():
	mouse_inside = !mouse_inside
	if !slot_in_game:
		show_description_timer.start(2.0)

func _on_inner_border_mouse_entered():
	mouse_inside = !mouse_inside
	if !slot_in_game:
		show_description_timer.start(2.0)

func _on_inner_border_mouse_exited():
	mouse_inside = !mouse_inside
	show_description_timer.stop()
	remove_panels_timer.start(0.6)

func _on_outer_border_mouse_exited():
	pass
	mouse_inside = !mouse_inside
	show_description_timer.stop()
	remove_panels_timer.start(0.6)
	

func _input(event):
	if mouse_inside and item !=null:
		if event.is_action_pressed("left_click"):
			pass
		elif event.is_action_pressed("right_click"):
			pass


func _on_timer_timeout():
	if mouse_inside and item !=null:
		details_panel.visible = true


func _on_remove_panels_timer_timeout():
	if !mouse_inside:
		details_panel.visible = false
		usage_panel.visible = false

func set_empty():
	icon.texture = null
	quantity.text = ""
	item_name.text = ""
	item_description.text = ""
	item_type.text = ""
	item = null

func set_item(new_item, is_in_game):
	item = new_item
	icon.texture = item["item_texture"]
	quantity.text = str(item["quantity"])
	item_name.text = item["item_name"]
	item_description.text = item["item_effect"]
	item_type.text = item["item_type"]
	slot_in_game = is_in_game
