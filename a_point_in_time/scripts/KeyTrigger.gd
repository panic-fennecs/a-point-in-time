extends Node2D

var key_item_scene = preload("res://scenes/KeyItem.tscn")

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func trigger():
	# remove old key
	get_node("/root/Node2D/Key").queue_free()
	# add key item
	var key_item = key_item_scene.instance()
	get_node("/root/Node2D/").add_child(key_item)