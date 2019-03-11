extends Camera2D

var player
var dialog_visible

func _ready():
	player = get_node("/root/Node2D/Player")
	$DialogCanvas.connect("dialog_started", self, "on_dialog_started")
	$DialogCanvas.connect("dialog_finished", self, "on_dialog_finished")
	
func _process(delta):
	if !dialog_visible:
		position = player.position
		
func on_dialog_started():
	dialog_visible = true
	
func on_dialog_finished():
	dialog_visible = false