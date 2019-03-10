extends AnimatedSprite

var first_future = false
var time_controller = null
var new_time_state = null

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	self.play("default")

func start_travel(tc, nts):
	start_animation()
	time_controller = tc
	new_time_state = nts

func start_animation():
	self.play("open")

func change_time():
	get_node("/root/Node2D/AnimationController").start_animation()
	time_controller.change_time_callback(new_time_state)

func _on_animation_finished():
	if self.animation == "open":
		self.play("close")
		change_time()
	elif self.animation == "close":
		self.play("default")