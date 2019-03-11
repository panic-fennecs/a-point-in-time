extends AnimatedSprite

var first_future = true
var time_controller = null
var new_time_state = null
var is_in_animation = false
var has_mod

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	self.play("default")

func start_travel(tc, nts, has_mod_arg):
	is_in_animation = true
	self.play("open")
	time_controller = tc
	new_time_state = nts
	has_mod = has_mod_arg

func in_animation():
	return is_in_animation

func change_time():
	get_node("/root/Node2D/AnimationController").start_animation()
	time_controller.change_time_callback(new_time_state, has_mod)

func _on_animation_finished():
	if self.animation == "open":
		change_time()
		play("default")
	elif self.animation == "close":
		self.play("default")
		is_in_animation = false
			
		if first_future:
			first_future = false
			get_node("/root/Node2D/PlayerCamera/DialogCanvas").show_dialog("first-future")