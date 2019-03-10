extends Node2D

export var shelf_id = 0

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func trigger():
	if shelf_id == 0:
		pass
	elif shelf_id == 1:
		pass
	elif shelf_id == 2:
		pass