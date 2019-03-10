extends Node2D

var dialog_controller

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self)
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
	
func _process(delta):
	self.visible = get_node("/root/Node2D/PlantManager").is_grown()

func trigger():
	if self.visible:
		dialog_controller.show_dialog("sheet")
	else:
		dialog_controller.show_dialog("empty-table")