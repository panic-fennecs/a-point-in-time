extends Node2D

var bulb_item_scene = preload("res://scenes/BulbItem.tscn")
var lamp_obj_scene = preload("res://scenes/Lamp.tscn")

"""
PRESENT_LAMP:
	Bulb is built into the lamp in the present
INVENTORY:
	Bulb is in inventory
FUTURE_LAMP:
	Bulb is built into the lamp in the future
"""

enum BulbState {
	PRESENT_LAMP,
	INVENTORY,
	FUTURE_LAMP,
}

var bulb_state = PRESENT_LAMP

func _ready():
	var lamp_obj = lamp_obj_scene.instance()
	add_child(lamp_obj)

func goto_future():
	if bulb_state == PRESENT_LAMP:
		get_node("./Lamp/AnimatedSprite").play("off")
	elif bulb_state == INVENTORY:
		pass # lamp still off
	elif bulb_state == FUTURE_LAMP:
		get_node("./Lamp/AnimatedSprite").play("on")

func goto_present():
	if bulb_state == PRESENT_LAMP:
		get_node("./Lamp/AnimatedSprite").play("on")
	elif bulb_state == INVENTORY:
		pass # lamp still off
	elif bulb_state == FUTURE_LAMP:
		get_node("./Lamp/AnimatedSprite").play("off")

func _add_item():
	var bulb_item = bulb_item_scene.instance()
	add_child(bulb_item)

func _remove_item():
	$BulbItem.queue_free()

func _take_bulb():
	print("taking bulb")
	_add_item()
	get_node("./Lamp/AnimatedSprite").play("off")
	bulb_state = INVENTORY

func _insert_bulb_in_future():
	_remove_item()
	get_node("./Lamp/AnimatedSprite").play("on")
	bulb_state = FUTURE_LAMP

func _insert_bulb_in_present():
	_remove_item()
	get_node("./Lamp/AnimatedSprite").play("on")
	bulb_state = PRESENT_LAMP

func _touch_missing_bulb_in_future():
	assert (bulb_state == PRESENT_LAMP)
	print('This bulb is broken. Don\'t use it. TODO: Move to UI.')

func on_touch_bulb_lamp():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if bulb_state == PRESENT_LAMP:
			_touch_missing_bulb_in_future()
		elif bulb_state == INVENTORY:
			_insert_bulb_in_future()
		elif bulb_state == FUTURE_LAMP:
			_take_bulb()
	else:
		if bulb_state == PRESENT_LAMP:
			_take_bulb()
		elif bulb_state == INVENTORY:
			_insert_bulb_in_present()
		elif bulb_state == FUTURE_LAMP:
			print("no lamp, sry")