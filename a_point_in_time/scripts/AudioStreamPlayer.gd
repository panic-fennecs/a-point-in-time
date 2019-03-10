extends AudioStreamPlayer

var mumble0 = preload("res://audio/mumble0.ogg")
var mumble1 = preload("res://audio/mumble1.ogg")
var mumble2 = preload("res://audio/mumble2.ogg")
var mumble3 = preload("res://audio/mumble3.ogg")
var mumble4 = preload("res://audio/mumble5.ogg")
var mumbles = [mumble0, mumble1, mumble2, mumble3, mumble4]
var time_machine_warp = preload("res://audio/time_machine_warp.ogg")
# TODO: var background = preload("res://audio/path_to_background.ogg")

var players = []

func _ready():
	"""
	TODO:
	var music_player = AudioStreamPlayer.new()
	background.set_loop(true)
	music_player.stream = background
	music_player.volume_db = -12
	add_child(music_player)
	music_player.play()
	"""
	pass

func _physics_process(delta):
	for p in players:
		if not p.is_playing():
			players.erase(p)
			p.queue_free()
			break

func playStream(pathToFile):
	var player = AudioStreamPlayer.new()
	pathToFile.set_loop(false)
	player.stream = pathToFile
	add_child(player)
	player.play()

	players.append(player)

func play_mumble(index):
	if index == -1:
		index = randi() % mumbles.size()
	else:
		index = index % mumbes.size()
	playStream(mumbles[index])

func play_time_machine_warp():
	playStream(time_machine_warp)