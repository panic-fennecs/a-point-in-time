extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

enum TimeState { PRESENT, FUTURE }

export var time_state = PRESENT

const MANAGERS = ["BulbManager", "PlantManager", "Map", "FutureMap"]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func change_time(new_time_state):
	time_state = new_time_state
	
	var m = []
	for x in MANAGERS: m.append(get_node("/root/Node2D/" + x))
	
	if time_state == PRESENT:
		for x in m: x.goto_present();
	elif time_state == FUTURE:
		for x in m: x.goto_future();
	else:
		assert(false)

func is_present():
	return time_state == PRESENT

func is_future():
	return time_state == FUTURE