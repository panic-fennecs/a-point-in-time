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

var bulb_state = LAYING

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

func _remove_inventar():
	get_child(0).queue_free()

func _add_item():
	var bulb_item = bulb_item_scene.instance()
	add_child(bulb_item)

func _remove_bulb():
	get_child(0).queue_free()

func _remove_item():
	get_child(0).queue_free()

func _add_functional_bulb():
	var bulb_obj = bulb_obj_scene.instance()
	add_child(bulb_obj)

func take_bulb_in_present():
	assert (bulb_state == LAYING)
	print("taking bulb in present")
	_remove_bulb()
	_add_item()
	bulb_state = INVENTORY

func touch_broken_bulb_in_future():
	assert (bulb_state == LAYING)
	print('This bulb is broken. Don\'t use it. TODO: Move to UI.')

func use_bulb_in_future():
	_remove_item()
	print("using bulb in future")
	bulb_state = USED

func on_touch_bulb_table():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if bulb_state == LAYING:
			touch_broken_bulb_in_future()
		elif bulb_state == INVENTORY:
			pass
		elif bulb_state == USED:
			pass
	else:
		if bulb_state == LAYING:
			take_bulb_in_present()
		elif bulb_state == INVENTORY:
			pass
		elif bulb_state == USED:
			pass

func on_touch_bulb_lamp():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if bulb_state == LAYING:
			touch_broken_bulb_in_future()
		elif bulb_state == INVENTORY:
			use_bulb_in_future()
		elif bulb_state == USED:
			pass
	else:
		if bulb_state == LAYING:
			pass
		elif bulb_state == INVENTORY:
			pass
		elif bulb_state == USED:
			pass