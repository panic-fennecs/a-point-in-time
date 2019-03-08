extends Node2D

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func trigger():
	print("wupwup")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
