extends Node2D

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func trigger():
	get_node("/root/Node2D/PlantManager").on_touch_table()