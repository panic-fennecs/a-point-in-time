extends Camera2D

var player

func _ready():
	player = get_node("/root/Node2D/Player")

func _process(delta):
	position = player.position