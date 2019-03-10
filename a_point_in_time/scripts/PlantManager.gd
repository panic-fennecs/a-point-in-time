extends Node2D

var seed_scene = preload("res://scenes/Seed.tscn")
var seed_item_scene = preload("res://scenes/SeedItem.tscn")

var dialog_controller

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

var POT_POSITION = null
var SEED_TABLE_POSITION = null

var seed_node = null
var seed_item_node = null

func _ready():
	POT_POSITION = get_node("/root/Node2D/TriggerController/PotTrigger").position
	SEED_TABLE_POSITION = get_node("/root/Node2D/TriggerController/SeedTableTrigger").position
	
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")

func goto_future():
	update()

func goto_present():
	update()

func _add_item():
	var seed_item = seed_item_scene.instance()
	seed_item_node = seed_item
	add_child(seed_item)

func _add_seed(pos):
	var seed_obj = seed_scene.instance()
	seed_node = seed_obj
	seed_obj.position = pos
	add_child(seed_obj)

func on_touch_table():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut and plant_state == SEED_ON_TABLE_FUTURE:
		dialog_controller.show_dialog("take-seed-future")
		plant_state = SEED_IN_INVENTORY
	else:
		print("wow, an empty table")

	update()

func on_touch_pot():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if plant_state == SEED_IN_POT_FUTURE:
			plant_state = SEED_IN_INVENTORY
		elif plant_state == SEED_IN_INVENTORY:
			plant_state = SEED_IN_POT_FUTURE
			dialog_controller.show_dialog("plant-future")
		elif plant_state == SEED_IN_POT_PRESENT:
			dialog_controller.show_dialog("flower")
		elif plant_state == SEED_ON_TABLE_FUTURE:
			print("wow, an empty pot")
	else:
		if plant_state == SEED_IN_POT_FUTURE:
			print("you can't do nothing, boii")
		elif plant_state == SEED_IN_INVENTORY:
			dialog_controller.show_dialog("plant-present")
			plant_state = SEED_IN_POT_PRESENT
		elif plant_state == SEED_IN_POT_PRESENT:
			dialog_controller.show_dialog("take-seed-present")
			plant_state = SEED_IN_INVENTORY
		elif plant_state == SEED_ON_TABLE_FUTURE:
			print("wow, an empty pot")

	update()

func reset():
	if seed_node:
		seed_node.queue_free()
		seed_node = null

	if seed_item_node:
		seed_item_node.queue_free()
		seed_item_node = null

func update():
	reset()

	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if plant_state == SEED_IN_POT_FUTURE:
			get_node("./Plant/AnimatedSprite").play("seed")
		elif plant_state == SEED_IN_INVENTORY:
			_add_item()
			get_node("./Plant/AnimatedSprite").play("empty")
		elif plant_state == SEED_IN_POT_PRESENT:
			get_node("./Plant/AnimatedSprite").play("plant")
		elif plant_state == SEED_ON_TABLE_FUTURE:
			get_node("./Plant/AnimatedSprite").play("empty")
			_add_seed(SEED_TABLE_POSITION)
	else:
		if plant_state == SEED_IN_POT_FUTURE:
			get_node("./Plant/AnimatedSprite").play("empty")
		elif plant_state == SEED_IN_INVENTORY:
			get_node("./Plant/AnimatedSprite").play("empty")
			_add_item()
		elif plant_state == SEED_IN_POT_PRESENT:
			get_node("./Plant/AnimatedSprite").play("seed")
		elif plant_state == SEED_ON_TABLE_FUTURE:
			get_node("./Plant/AnimatedSprite").play("empty")

func is_grown():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	return plant_state == SEED_IN_POT_PRESENT and fut