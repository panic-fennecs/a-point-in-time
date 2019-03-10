extends CanvasLayer

var dialog_visible
var phrases
var current_phrase = 0
var frame_count = null

signal dialog_started
signal dialog_finished

const STRING_DICT = {
	# chapter 1
	"enter-basement": ["The old basement of my grandpa. I remember playing here as a child alot.","I still can't manage the thought of having inherited my grandpa's old mansion.", "I think I'm gonna look around a bit."],
	"discover-timemachine": ["Hm.. wierd, can't remember this room.", "What kind of machine is this? Sign says \"Time Machine (Dr. E. Brown Enterprises)\".", "Haha my old gramps always loved jokes like that.", "This reminds me of doctor who and the tardis. I wonder how this thing looks from the inside."],
	"first-future": ["Woa.. what happend?, I feel a bit dizzy.", "(looks around)", "Has the room changed?", "Hm.. the calender on the wall points to a date in the year 2029. That's got to be a trick, right?"],
	# explore
	"take-seed-future-table": ["This seed's lying around here like it's important.", "Maybe I'll find a good place for it."],
	"plant-seed-future": ["Okay, this will take ages to grow..", "Hm.. what am I doing here."],
	"plant-seed-present": ["I wonder what the full-grown flower will look like.", "Burb.. sorry."],
	
	"take-seed-future-pot": ["Maybe the right place for this seed is in another spot.", "Let's see.. (thinking)"],
	"take-seed-present-pot": ["Oh.. now I've got that thing again. Perhaps I should leave it here.", "I wonder how this will look in the future."],
	
	"inspect-flower": ["Neat! This is a Ipomoea.", "Grandpa always put this flower next to grandma's bed, so that she had always felt comfortable in her dreams.", "Phew.. okay enough thoughts about the past, back to the time machine topic.", "This tiny seed evolved into this beautiful Ipomoea. And it aged through my time travel.", "That means I can cause things to change by alter the \"Present\". Maybe there is a lot more possible with this machine."],

	# chapter 2
	"take-key": ["A key.. what a an innovative idea.. (sigh)", "Out of spite I could leave him lying here, but I should probably take him with me."],
	"empty-table": ["Regular table here.. nothing special i guess.", "C'mon Mabel lets do something productive."],
	"taking-bulb": ["This comes handy. ", "... wow"],
	"dark-room": ["Crap I can't see anything. I'm gonna stumble and hurt myself.", "Going into a basement without a flashlight isn't the brightest idea.", "Haha \"brightest idea\"." ],
	"still-dark-room": ["Still dark.. lets get back here when I found something useful."],
	"broken-bulb": ["Hm.. there seems to be a broken bulb in the lamp socket, so I can't turn on the light."]
}

func _input(event):
	if !dialog_visible:
		return
	
	if event is InputEventKey:
        if event.pressed and Input.is_action_just_pressed("ui_accept"):
            next_phrase()

func show_dialog(key):
	if frame_count == null:
		frame_count = $DialogSprite.frames.get_frame_count("default")
	assert(!dialog_visible)
	if STRING_DICT.keys().has(key):
		phrases = STRING_DICT[key]
	else:
		phrases = ["I don't even know what to say.."] # fallback
	dialog_visible = true
	emit_signal("dialog_started")
	update_dialog_visibilty()
	$DialogSprite.frame = randi() % frame_count
	$DialogLabel.text = phrases[current_phrase]
	AudioPlayer.play_mumble(-1)
	
func update_dialog_visibilty():
	$DialogLabel.visible = dialog_visible
	$DialogSprite.visible = dialog_visible

func next_phrase():
	current_phrase += 1
	if current_phrase == len(phrases): # reset
		dialog_visible = false
		emit_signal("dialog_finished")
		phrases = []
		current_phrase = 0
		update_dialog_visibilty()
		return

	$DialogSprite.frame = randi() % frame_count
	$DialogLabel.text = phrases[current_phrase]
	
	