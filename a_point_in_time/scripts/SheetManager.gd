extends Node2D

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self)

func _process(delta):
	self.visible = get_node("/root/Node2D/PlantManager").is_grown()

func trigger():
	if self.visible:
		var c = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
		c.show_dialog("sheet")