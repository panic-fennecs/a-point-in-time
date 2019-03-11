extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

enum TimeState { PRESENT, FUTURE }

export var time_state = PRESENT

const MANAGERS = ["BulbManager", "PlantManager", "KeyManager", "Map", "FutureMap", "Tresor", "Door"]

func change_time(new_time_state, has_mod):
	get_node("/root/Node2D/TimeMachine/AnimatedSprite").start_travel(self, new_time_state, has_mod)

func change_time_callback(new_time_state, has_mod):
	if has_mod:
		get_tree().change_scene("res://scenes/EndScene.tscn")
		AudioPlayer.play_end_music()
	else:
		time_state = new_time_state
		
		var m = []
		for x in MANAGERS: m.append(get_node("/root/Node2D/" + x))
		
		if time_state == PRESENT:
			for x in m: x.goto_present();
			get_node("CanvasLayer/Label").text = "PRESENT"
		elif time_state == FUTURE:
			for x in m: x.goto_future();
			get_node("CanvasLayer/Label").text = "FUTURE"
		else:
			assert false

func is_present():
	return time_state == PRESENT

func is_future():
	return time_state == FUTURE
