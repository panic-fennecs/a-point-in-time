
extends Node2D

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func trigger():
	print("tresor und so")