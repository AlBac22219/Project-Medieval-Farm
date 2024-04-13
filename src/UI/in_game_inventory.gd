extends Control

@export var h_box_cont: HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_update.connect(update_inventory)
	update_inventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_inventory():
	clear_h_box_container()
	var i = 0
	for item in Global.inventory:
		var slot = Global.inventory_slot_scene.instantiate()
		if item != null:
			slot.set_item(item, true)
		else:
			slot.set_empty()
		h_box_cont.add_child(slot)
		i +=1
		if i == 10:
			break

func clear_h_box_container():
	while h_box_cont.get_child_count()>0:
		var child = h_box_cont.get_child(0)
		h_box_cont.remove_child(child)
		child.queue_free()
