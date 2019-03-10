extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var triggers = []
var floor_triggers = []

func add_trigger(trigger):
	triggers.append(trigger);

func add_floor_trigger(trigger):
	floor_triggers.append(trigger)

func clear_triggers():
	triggers.clear();
	floor_triggers.clear();

# pos: Vector2i
func click_position(pos):
	for t in triggers:
		var int_x = int(t.position.x / 64)
		var int_y = int(t.position.y / 64)
		if pos.x < 0:
			int_x -= 1
		if pos.y < 0:
			int_y -= 1
		if int_x == pos.x and int_y == pos.y:
			t.trigger()

func stand_position(pos):
	for t in floor_triggers:
		if int(t.position.x / 64) == pos.x and int(t.position.y / 64) == pos.y:
			t.floor_trigger()


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
