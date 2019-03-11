extends AudioStreamPlayer

var mumble0 = preload("res://audio/mumble0.ogg")
var mumble1 = preload("res://audio/mumble1.ogg")
var mumble2 = preload("res://audio/mumble2.ogg")
var mumble3 = preload("res://audio/mumble3.ogg")
var mumble4 = preload("res://audio/mumble5.ogg")
var mumbles = [mumble0, mumble1, mumble2, mumble3, mumble4]

var step1 = preload("res://audio/steps/step1.ogg")
var step2 = preload("res://audio/steps/step2.ogg")
var step3 = preload("res://audio/steps/step3.ogg")
var steps = [step1, step2, step3]

var click = preload("res://audio/click.ogg")
var door = preload("res://audio/door.ogg")
var time_machine_warp = preload("res://audio/time_machine_warp.ogg")

var background = preload("res://audio/a_point_in_time.ogg")
var end_music = preload("res://audio/song_2.ogg")

const FADE_OUT_LEVEL = 30
var fade_out_level = 0
var fade_out = false

var players = []
var background_player = AudioStreamPlayer.new()
var end_music_player = AudioStreamPlayer.new()

func _ready():
	background.set_loop(true)
	background_player.stream = background
	# music_player.volume_db = -12
	add_child(background_player)
	background_player.play()

func _process(delta):
	if fade_out:
		fade_out_level -= (delta * 10)
		background_player.volume_db = fade_out_level
		end_music_player.volume_db = -fade_out_level -FADE_OUT_LEVEL - 7

		if fade_out_level < -FADE_OUT_LEVEL:
			background_player.stop()
			background_player.queue_free()
			fade_out = false

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

func playStreamWithDB(file, db):
	var player = AudioStreamPlayer.new()
	file.set_loop(false)
	player.stream = file
	player.volume_db = db
	add_child(player)
	player.play()

	players.append(player)

func play_mumble(index):
	if index == -1:
		index = randi() % mumbles.size()
	else:
		index = index % mumbles.size()
	playStream(mumbles[index])

func play_time_machine_warp():
	playStream(time_machine_warp)

func play_click():
	playStreamWithDB(click, -12)

func play_door():
	playStreamWithDB(door, -4)

func play_step():
	var index = randi() % steps.size()
	var db = -(randi() % 4)
	playStreamWithDB(steps[index], db-4)

func play_end_music():
	fade_out = true
	
	end_music.set_loop(true)
	end_music_player.stream = end_music
	end_music_player.volume_db = -FADE_OUT_LEVEL
	add_child(end_music_player)
	end_music_player.play()