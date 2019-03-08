extends Node2D

var bulb_item_scene = preload("res://scenes/BulbItem.tscn")
var bulb_obj_scene = preload("res://scenes/BulbObj.tscn")

"""
You can take a functioning bulb from a desk into inventory.
You can't take a broken bulb from a desk. -> Error: "This bulb is broken"
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

func bulb_pressed():
	if time_state == PRESENT:
		if bulb_state == LAYING:
			# remove laying bulb
			get_child(0).queue_free()
			# add bulb into inventory
			var bulb_item = bulb_item_scene.instance()
			add_child(bulb_item)
		elif bulb_state == INVENTORY:
			get_child(0).queue_free()
		elif bulb_state == USED:
			print("Error: Dont use the used bulb in the present. Unless it's ok. Then remove this print :)")
	else: # FUTURE
		if bulb_state == LAYING:
			print('This bulb is broken. Don\'t use it')
		elif bulb_state == INVENTORY:
			# remove from inventory
			get_child(0).queue_free()
			# let it shine
		elif bulb_state == USED:
			print("Error: Dont use the used bulb. Unless it's ok. Then remove this print :)")