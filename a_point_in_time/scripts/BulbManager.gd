extends Node2D

var bulb_item_scene = preload("res://scenes/BulbItem.tscn")
var lamp_obj_scene = preload("res://scenes/Lamp.tscn")
var dankness_scene = preload("res://scenes/Dankness.tscn")

var bulb_state = PRESENT_LAMP
var dialog_controller
var dankness_tiles = []

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


func _ready():
	var lamp_obj = lamp_obj_scene.instance()
	add_child(lamp_obj)
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
	dialog_controller.get_node("DialogLabel").margin_left = 140
	for x in range(4, 9):
		for y in range(12, 18):
			if [7, 8].has(x) and [12, 13].has(y):
				continue
			var t = dankness_scene.instance()
			t.get_child(0).play("default")
			t.position.x = x * 64 + 32
			t.position.y = y * 64 + 32
			add_child(t)
			t.hide()
			dankness_tiles.append(t)

func _lamp_off():
	get_node("./Lamp/AnimatedSprite").play("off")
	for t in dankness_tiles: t.show()

func _lamp_on():
	get_node("./Lamp/AnimatedSprite").play("on")
	for t in dankness_tiles: t.hide()

func goto_future():
	if bulb_state == PRESENT_LAMP:
		_lamp_off()
	elif bulb_state == INVENTORY:
		pass # lamp still off
	elif bulb_state == FUTURE_LAMP:
		_lamp_on()

func goto_present():
	if bulb_state == PRESENT_LAMP:
		_lamp_on()
	elif bulb_state == INVENTORY:
		pass # lamp still off
	elif bulb_state == FUTURE_LAMP:
		_lamp_off()

func _add_item():
	var bulb_item = bulb_item_scene.instance()
	add_child(bulb_item)

func _remove_item():
	$BulbItem.queue_free()

func _take_bulb():
	#print("taking bulb")
	dialog_controller.show_dialog("taking-bulb")
	_add_item()
	_lamp_off()
	bulb_state = INVENTORY

func _insert_bulb_in_future():
	_remove_item()
	_lamp_on()
	bulb_state = FUTURE_LAMP
	dialog_controller.show_dialog("inserting-bulb")

func _insert_bulb_in_present():
	_remove_item()
	_lamp_on()
	bulb_state = PRESENT_LAMP
	dialog_controller.show_dialog("inserting-bulb")

func _touch_missing_bulb_in_future():
	assert (bulb_state == PRESENT_LAMP)
	dialog_controller.show_dialog("broken-bulb")

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