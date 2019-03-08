extends Node2D

var seed_scene = preload("res://scenes/Seed.tscn")
var seed_item_scene = preload("res://scenes/SeedItem.tscn")
var plant_scene = preload("res://scenes/Plant.tscn")

"""
SEED_IN_FUTURE:
	Seed is in FlowerPot in future.
SEED_IN_INVENTORY:
	Seed is in Inventory.
SEED_IN_PRESENT:
	Seed is planted in present and plant in future
"""
enum PlantState {
	SEED_IN_FUTURE,
	SEED_IN_INVENTORY,
	SEED_IN_PRESENT
}

enum TimeState {
	PRESENT,
	FUTURE
}

var plant_state = SEED_IN_FUTURE
var time_state = PRESENT

func goto_future():
	pass

func goto_present():
	pass

func _remove_item():
	get_child(0).queue_free()

func _remove_seed():
	get_child(0).queue_free()

func _add_item():
	var seed_item = seed_item.instance()
	add_child(seed_item)

func _add_seed():
	var seed_obj = seed_scene.instance()
	add_child(seed_obj)

func plant_seed_in_present():
	assert (time_state == PRESENT) and (plant_state == SEED_IN_INVENTORY)
	_remove_item()
	_add_seed()
	
	plant_state = SEED_IN_PRESENT

func take_seed_in_present():
	assert plant_state == SEED_IN_PRESENT
	assert time_state == PRESENT
	
	_remove_seed()
	_add_item()
	
	plant_state = SEED_IN_INVENTORY

func take_seed_in_future():
	assert time_state == FUTURE
	assert plant_state == SEED_IN_FUTURE
	
	_remove_seed()
	_add_item()
	
	plant_state = SEED_IN_INVENTORY

func plant_seed_in_future():
	assert time_state == FUTURE
	assert plant_state == SEED_IN_INVENTORY
	
	_remove_item()
	_add_seed()
	
	plant_state == SEED_IN_FUTURE

func touch_plant_in_future():
	# TODO: Move to UI
	print("This is a pretty flower :)")