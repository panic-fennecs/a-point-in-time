extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var triggers = []

func add_trigger(trigger):
	triggers.append(trigger);

func clear_triggers():
	triggers.clear();

# pos: Vector2i
func click_position(pos):
	for t in triggers:
		if int(t.position.x / 64) == pos.x and int(t.position.y / 64) == pos.y:
			t.trigger()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
