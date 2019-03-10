extends Node2D

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func other(t):
	var c = get_node("/root/Node2D/TimeController")
	if t == c.TimeState.FUTURE:
		return c.TimeState.PRESENT
	elif t == c.TimeState.PRESENT:
		return c.TimeState.FUTURE
	else:
		assert(false)

func trigger():
	var c = get_node("/root/Node2D/TimeController")
	c.change_time(other(c.time_state))
	if c.is_present():
		print("welcome to present!")
	else:
		print("welcome to future!")
	AudioPlayer.play_time_machine_warp()