extends Node2D

enum KeyState {
	ON_TABLE,
	IN_INVENTORY
}

var key_item_scene = preload("res://scenes/KeyItem.tscn")
var key_scene = preload("res://scenes/Key.tscn")

var key_state = ON_TABLE

var key_node = null
var key_item = null

var dialog_controller

var KEY_POSITION = null

func _ready():
	KEY_POSITION = get_node("/root/Node2D/TriggerController/KeyTrigger").position

	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")

func reset():
	if key_node:
		key_node.queue_free()
		key_node = null

	if key_item:
		key_item.queue_free()
		key_item = null

func goto_future():
	update()

func goto_present():
	update()

func add_key_item():
	key_item = key_item_scene.instance()
	add_child(key_item)

func add_key_node():
	key_node = key_scene.instance()
	key_node.position = KEY_POSITION
	add_child(key_node)

func update():
	reset()

	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if key_state == ON_TABLE:
			add_key_node()
		elif key_state == IN_INVENTORY:
			add_key_item()
	else: # PRESENT
		if key_state == ON_TABLE:
			pass
		elif key_state == IN_INVENTORY:
			add_key_item()

func on_touch_table():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	
	if fut:
		if key_state == ON_TABLE:
			key_state = IN_INVENTORY
			dialog_controller.show_dialog("take-key")
		elif key_state == IN_INVENTORY:
			print("empty table")
	else:
		if key_state == ON_TABLE:
			dialog_controller.show_dialog("no-key-in-present")
		elif key_state == IN_INVENTORY:
			print("empty table again")

	update()

func player_has_key():
	return key_state == IN_INVENTORY