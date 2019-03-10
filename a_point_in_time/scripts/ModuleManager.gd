extends Node2D

var in_inv = false

var module_item_scene = preload("res://scenes/ModuleItem.tscn")

var dialog_controller

func _ready():
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")

func take_module():
	in_inv = true
	add_child(module_item_scene.instance())

func player_has_module():
	return in_inv