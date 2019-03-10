extends Node2D

export var is_X = true
var initial_try = true

func _ready():
	get_node("/root/Node2D/TriggerController").add_floor_trigger(self);

func floor_trigger():
	var lamp_sprite = get_node("/root/Node2D/BulbManager/Lamp/AnimatedSprite")
	if lamp_sprite.animation == "off":
		var player = get_node("/root/Node2D/Player")
		var dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
		if is_X:
			player.move_right()
		else:
			player.move_top()
		
		if initial_try:
			dialog_controller.show_dialog("dark-room")
			initial_try = false
		else:
			dialog_controller.show_dialog("still-dark-room")