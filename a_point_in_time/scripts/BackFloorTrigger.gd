extends Node2D

export var is_X = true

func _ready():
	get_node("/root/Node2D/TriggerController").add_floor_trigger(self);

func floor_trigger():
	var player = get_node("/root/Node2D/Player")
	var dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
	if is_X:
		player.move_left()
	else:
		player.move_bot()
	dialog_controller.show_dialog("dark")