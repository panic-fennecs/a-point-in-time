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

func _conv(w):
	var int_ = int(w / 64)
	if w < 0:
		int_ -= 1
	return int_

# pos: Vector2i
func click_position(pos):
	var any = false
	for t in triggers:
		var int_x = _conv(t.position.x)
		var int_y = _conv(t.position.y)
		if int_x == pos.x and int_y == pos.y:
			any = true
			t.trigger()
	if any:
		play_click()

func stand_position(pos):
	for t in floor_triggers:
		var int_x = _conv(t.position.x)
		var int_y = _conv(t.position.y)
		if int_x == pos.x and int_y == pos.y:
			t.floor_trigger()

func is_clickable(x, y):
	for t in triggers:
		var int_x = _conv(t.position.x)
		var int_y = _conv(t.position.y)
		if x == int_x and y == int_y:
			return true
	return false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func play_click():
	get_node("/root/AudioPlayer").play_click()