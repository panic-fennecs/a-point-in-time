extends Node2D

var already_seen = false

func _ready():
	get_node("/root/Node2D/TriggerController").add_floor_trigger(self);

func floor_trigger():
	if !already_seen:
		get_node("/root/Node2D/PlayerCamera/DialogCanvas").show_dialog("discover-tm")
		already_seen = true