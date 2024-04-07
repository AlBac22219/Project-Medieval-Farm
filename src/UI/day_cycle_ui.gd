extends Control

@export var timer: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_day_time(day, hour, minutes):
	timer.text= "День: " + str(day) + "\nЧас: " + str(hour) + "\nМинута: " + str(minutes) 
