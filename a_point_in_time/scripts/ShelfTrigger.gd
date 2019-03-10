extends Node2D

export var shelf_id = 0
var found_secret = false
var dialog_controller

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")

func trigger():
	if shelf_id == 0:
		dialog_controller.show_dialog("shelf-scroll")
	elif shelf_id == 1:
		dialog_controller.show_dialog("shelf-empty")
	elif shelf_id == 2:
		if found_secret:
			dialog_controller.show_dialog("shelf-empty")
		else:
			dialog_controller.show_dialog("shelf-found-secret")
			found_secret = true