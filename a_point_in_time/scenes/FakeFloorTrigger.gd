extends Node2D

func _ready():
	get_node("/root/Node2D/TriggerController").add_floor_trigger(self);

func floor_trigger():
	print("wupwupwup!!!")