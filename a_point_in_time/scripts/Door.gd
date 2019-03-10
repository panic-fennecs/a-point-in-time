extends Node2D

enum DoorState { OPEN, CLOSED }

var door_state = CLOSED

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self)
	_update()

func trigger():
	var c = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
	if door_state == CLOSED and get_node("/root/Node2D/KeyManager").player_has_key():
		door_state = OPEN
		_update()

func _update():
	if door_state == CLOSED:
		get_node("./AnimatedSprite").play("closed")
	else:
		get_node("./AnimatedSprite").play("open")

func is_closed():
	return door_state == CLOSED