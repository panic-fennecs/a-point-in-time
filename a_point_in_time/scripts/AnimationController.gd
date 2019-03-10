extends Node2D

var is_in_animation = false
var time_passed = 0
const ANIMATION_TIME = 1.15

func _process(delta):
	if is_in_animation:
		time_passed += delta
		if time_passed > ANIMATION_TIME:
			stop_animation()

func in_animation():
	return is_in_animation

func start_animation():
	time_passed = 0
	get_node("CanvasLayer/AnimatedSprite").visible = true
	is_in_animation = true
	print("start_animation")

func stop_animation():
	print("stop_animation()")
	is_in_animation = false
	get_node("CanvasLayer/AnimatedSprite").visible = false
	get_node("/root/Node2D/TimeMachine/AnimatedSprite").play("close")