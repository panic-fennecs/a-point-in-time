extends Node2D

var seed_scene = preload("res://scenes/Seed.tscn")
var seed_item_scene = preload("res://scenes/SeedItem.tscn")
var plant_scene = preload("res://scenes/Plant.tscn")

"""
SEED_ON_TABLE_FUTURE:
	Seed is on the table in the future.
SEED_IN_POT_FUTURE:
	Seed is in FlowerPot in future.
SEED_IN_INVENTORY:
	Seed is in Inventory.
SEED_IN_POT_PRESENT:
	Seed is planted in present and plant in future
"""
enum PlantState {
	SEED_ON_TABLE_FUTURE,
	SEED_IN_POT_FUTURE,
	SEED_IN_INVENTORY,
	SEED_IN_POT_PRESENT
}

var plant_state = SEED_ON_TABLE_FUTURE

# time changes:

func goto_future():
	if plant_state == SEED_IN_POT_FUTURE:
		_add_seed()
	elif plant_state == SEED_ON_TABLE_FUTURE:
		_add_seed()
	elif plant_state == SEED_IN_INVENTORY:
		# seed stays in inventory, everything is fine :)
		pass
	elif plant_state == SEED_IN_POT_PRESENT:
		_remove_seed()
		_add_plant()

func goto_present():
	if plant_state == SEED_IN_POT_FUTURE:
		_remove_seed()
	elif plant_state == SEED_ON_TABLE_FUTURE:
		_remove_seed()
	elif plant_state == SEED_IN_INVENTORY:
		pass
	elif plant_state == SEED_IN_POT_PRESENT:
		_remove_plant()
		_add_seed()

func _remove_item():
	get_child(0).queue_free()

func _remove_seed():
	get_child(0).queue_free()

func _remove_plant():
	get_child(0).queue_free()

func _add_item():
	var seed_item = seed_scene.instance()
	add_child(seed_item)

func _add_seed():
	var seed_obj = seed_scene.instance()
	add_child(seed_obj)

func _add_plant():
	var plant_obj = plant_scene.instance()
	add_child(plant_obj)

# trigger calls:

func plant_seed_in_present():
	assert plant_state == SEED_IN_INVENTORY
	print("planting seed in present")
	_remove_item()
	_add_seed()
	
	plant_state = SEED_IN_POT_PRESENT

func take_seed_in_present():
	assert plant_state == SEED_IN_POT_PRESENT
	print("taking seed in present")
	_remove_seed()
	_add_item()
	
	plant_state = SEED_IN_INVENTORY

func take_seed_in_future():
	assert plant_state == SEED_IN_POT_FUTURE or plant_state == SEED_ON_TABLE_FUTURE
	print("taking seed in future")
	_remove_seed()
	_add_item()
	
	plant_state = SEED_IN_INVENTORY

func plant_seed_in_future():
	assert plant_state == SEED_IN_INVENTORY
	print("planting seed in future")
	_remove_item()
	_add_seed()
	
	plant_state = SEED_IN_POT_FUTURE

func touch_plant_in_future():
	# TODO: Move to UI
	print("This is a pretty flower :)")

func on_touch_table():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut and plant_state == SEED_ON_TABLE_FUTURE:
		print("noice, a seed")
		take_seed_in_future()
	else:
		print("wow, an empty table")

func on_touch_pot():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if plant_state == SEED_IN_POT_FUTURE:
			take_seed_in_future()
		elif plant_state == SEED_IN_INVENTORY:
			plant_seed_in_future()
		elif plant_state == SEED_IN_POT_PRESENT:
			touch_plant_in_future()
		elif plant_state == SEED_ON_TABLE_FUTURE:
			print("wow, an empty pot")
	else:
		if plant_state == SEED_IN_POT_FUTURE:
			print("you can't do nothing, boii")
		elif plant_state == SEED_IN_INVENTORY:
			plant_seed_in_present()
		elif plant_state == SEED_IN_POT_PRESENT:
			take_seed_in_present()
		elif plant_state == SEED_ON_TABLE_FUTURE:
			print("wow, an empty pot")