extends Node2D

var bulb_item_scene = preload("res://scenes/BulbItem.tscn")
var bulb_obj_scene = preload("res://scenes/BulbObj.tscn")

"""
You can take a functioning bulb from a desk into inventory.
You can't take a broken bulb from a desk. -> Error: "This bulb is broken"

LAYING:
	Bulb lays functioning in present and broken in future
INVENTORY:
	Bulb is functioning in inventory
USED:
	Bulb is placed in future room
"""

enum BulbState {
	LAYING,
	INVENTORY,
	USED
}

enum TimeState {
	PRESENT,
	FUTURE
}

var bulb_state = LAYING
var time_state = PRESENT

func _ready():
	var bulb_obj = bulb_obj_scene.instance()
	add_child(bulb_obj)

func goto_future():
	if bulb_state == LAYING:
		# Remove functioning bulb in present
		get_child(0).queue_free()
		# Add broken bulb into future
		var bulb_object = bulb_obj_scene.instance()
		add_child(bulb_object)
	elif bulb_state == INVENTORY:
		# bulb stays in inventory
		pass
	elif bulb_state == USED:
		# Create working bulb in future
		var bulb_object = bulb_obj_scene.instance()
		add_child(bulb_object)
	time_state = FUTURE

func goto_present():
	if bulb_state == LAYING:
		# remove broken bulb
		get_child(0).queue_free()
		# add functioning bulb
		var bulb_object = bulb_obj_scene.instance()
		add_child(bulb_object)
	elif bulb_state == INVENTORY:
		# bulb stays in inventory
		pass
	elif bulb_state == USED:
		var bulb_object = bulb_obj_scene.instance()
		add_child(bulb_object)
	time_state = PRESENT

func _remove_inventar():
	get_child(0).queue_free()

func _add_item():
	var bulb_item = bulb_item_scene.instance()
	add_child(bulb_item)

func _remove_bulb():
	get_child(0).queue_free()

func _add_functional_bulb():
	var bulb_obj = bulb_obj_scene.instance()
	add_child(bulb_obj)

func take_bulb_in_present():
	assert (bulb_state == LAYING) and (time_state == PRESENT)
	_remove_bulb()
	_add_item()
	bulb_state = INVENTORY

func touch_broken_bulb_in_future():
	assert (bulb_state == LAYING) and (time_state == FUTURE)
	print('This bulb is broken. Don\'t use it. TODO: Move to UI.')

func use_bulb_in_future():
	_remove_item()
	bulb_state = USED