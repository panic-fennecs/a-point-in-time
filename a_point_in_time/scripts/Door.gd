extends Node2D

enum DoorState { OPEN_FUTURE, OPEN, CLOSED }

var door_state = CLOSED

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self)
	_update()

func trigger():
	var c = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if get_node("/root/Node2D/KeyManager").player_has_key():
		if fut:
			if door_state == CLOSED:
				door_state = OPEN_FUTURE
		else:
			if door_state != OPEN:
				door_state = OPEN
	_update()

func _update():
	if is_closed():
		get_node("./AnimatedSprite").play("closed")
	else:
		get_node("./AnimatedSprite").play("open")

func goto_future():
	_update()

func goto_present():
	_update()

func is_closed():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	return door_state == CLOSED or (door_state == OPEN_FUTURE and !fut)