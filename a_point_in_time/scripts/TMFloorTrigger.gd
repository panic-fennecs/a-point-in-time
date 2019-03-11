extends Node2D

var already_seen = false

func _ready():
	get_node("/root/Node2D/TriggerController").add_floor_trigger(self);

func floor_trigger():
	if !already_seen:
		get_node("/root/Node2D/PlayerCamera").position += Vector2(0,300)
		get_node("/root/Node2D/PlayerCamera/DialogCanvas").show_dialog("discover-timemachine")
		already_seen = true