extends CanvasLayer

var dialog_visible
var phrases
var current_phrase = 0
var frame_count = null
var knock_index = 0
var knock_joke_count = 6

signal dialog_started
signal dialog_finished

const STRING_DICT = {
	# intro
	"intro-sequence": [
		"Mabel, my dearest granddaughter…", 
		"This might be our last talk for a long time…", 
		"I'm so sorry, I didn't have a possibility to give you a proper goodbye… ", 
		"You might get really upset, thinking about the time you spent with me and grandma, but this old man is leaving you, unwillingly.", 
		"I will spent my last thoughts with you in my mind. Take care of grandma and our mansion she's getting more confused lately, a little side effect of getting old. I hope she'll be fine.", 
		"Remember with great power comes great responsibillity.", 
		"In love… \n\n…grandpa."],
	
	# chapter 1
	"enter-basement": ["The old basement of my grandpa. I remember playing here as a child alot. It's kinda sad that I couldn't spend much time with him.", "(sigh)","I still can't manage the thought of having inherited my grandpa's old mansion.", "I think I'm gonna look around a bit."],
	"discover-timemachine": ["Hm.. wierd, can't remember this room.", "What kind of machine is this? Sign says 'Time Machine (Dr. E. Brown Enterprises)'.", "Haha my old gramps always loved jokes like that.", "This reminds me of doctor who and the tardis. I wonder how this thing looks from the inside."],
	"first-future": ["Woa.. what happend?, I feel a bit dizzy.", "(looks around)", "Has the room changed?", "Hm.. the calender on the wall points to a date in the year 2029. That's got to be a trick, right?", "Grandpa, what were you doing down here?"],
	# explore
	"take-seed-future-table": ["This seed's lying around here like it's important.", "Maybe I'll find a good place for it."],
	"plant-seed-future": ["Okay, this will take ages to grow..", "Hm.. what am I doing here."],
	"plant-seed-present": ["I wonder what the full-grown flower will look like.", "Burb.. sorry."],
	
	"take-seed-future-pot": ["Maybe the right place for this seed is in another spot.", "Let's see.. (thinking)"],
	"take-seed-present-pot": ["Oh.. now I've got that thing again. Perhaps I should leave it here.", "I wonder how this will look in the future."],
	
	"inspect-flower": ["Neat! This is a Ipomoea.", "Grandpa always put this flower next to grandma's bed, so that she had always felt comfortable in her dreams.", "Phew.. okay enough thoughts about the past, back to the time machine topic.", "This tiny seed evolved into this beautiful Ipomoea. And it aged through my time travel.", "That means I can cause things to change by alter the 'Present'. Maybe there is a lot more possible with this machine."],

	# chapter 2
	"take-key": ["Key means opening locked things. Alright let's find some locked things, shall we?"],
	"empty-table": ["Regular table here.. nothing special i guess.", "C'mon Mabel lets do something productive."],
	"taking-bulb": ["This might come handy.", "There is probably another spot where I can screw this bulb in."],
	"dark-room": ["Crap I can't see anything. I'm gonna stumble and hurt myself.", "Going into a basement without a flashlight isn't the brightest idea.", "Haha 'brightest idea'." ],
	"still-dark-room": ["Still dark.. lets get back here when I found something useful."],
	"broken-bulb": ["Hm.. there seems to be a broken bulb in the lamp socket, so I can't turn on the light."],
	"sheet": [
		"This sheet wasn't here before!",
		"'Dear Stuart, thanks for the beautiful flower. One quick question: Why does it only bloom at night though?'",
		"'I left the key to the safe deposit room at the discussed place.'",
		"'xoxo Diana'", "'PS: Could you please travel back in time and get us a fine old bottle of red wine?'",
		"I'm sorry nan, but grandpa won't be able to read this. But thank you very much for all the information.",
		"Oh.. I didn't know that you can travel to the past. Maybe I'll find some information on it on one of the bookshelves.",
		"And maybe the mentioned key is stil there."],
	"empty-pot": ["If grandpa has a time machine, maybe this flower pot is futuristic as well.", "(turns around and reads sticker)", "'Ikea Muskot'.. I guess not."],
	"door-locked-0": ["Locked..", "Knock knock.", "Who's there?", "Robin.", "Robin who?", "Robin you, now hand over the cash.", "Hehe."],
	"door-locked-1": ["Locked..", "Knock knock.", "Who's there?", "Etch.", "Etch who?", "Bless you, friend.", "Hehe."],
	"door-locked-2": ["Locked..", "Knock knock.", "Who's there?", "Cash.", "Cash who?", "No thanks, I'll have some peanuts.", "Hehe."],
	"door-locked-3": ["Locked..", "Knock knock.", "Who's there?", "Tank.", "Tank who?", "You’re welcome.", "Hehe."],
	"door-locked-4": ["Locked..", "Knock knock.", "Who’s there?", "Spell.", "Spell who?", "Okay, okay: W. H. O.", "Hehe."],
	"door-locked-5": ["Locked..", "Knock knock.", "Who’s there?", "Candice.", "Candice who?", "Candice door open, or what?", "Seriously?"],
	"open-safe": ["There we go, finally!", "I'm curious whats inside!", "This looks like a circuit board for the time machine.", "The attached description says that you can travel back in time with it.", "'install instruction' gosh who needs that.."],
	"note-in-inventory": ["'old safe password: 1337'", "Nice!", "Let's try this one in the past."],
	"locked-safe": ["I'm not able to open the safe without a pin.", "(tries 0000)", "(nothing happened)", "(sigh)"],
	"shelf-scroll": ["Hm.. in this shelf are just some scrolls. Perhaps there is more information in one of the other once."],
	"shelf-empty": ["Nah.. there are no fancy books in here."],
	"shelf-found-secret": ["Uh one of the books looks old and selfmade.", "'To travel back in time you need an 'XS-Exchange module'. The module is stored in a safe place.'", "'Chapter 2: How to create a portal.", "I think this is not relevant."],
	
	# end
	"end-sequence": [
	"After Mabel traveled between the present and future, she successfully  completed the time machine's mechanism to reach the time in the past. Searching for her grandpa she suddenly stopped when she wanted to leave the basement…",
	"Grandpa!"],

	"inserting-bulb": ["Let there be light."],
}

func _input(event):
	if !dialog_visible:
		return
	
	if event is InputEventKey:
        if event.pressed and Input.is_action_just_pressed("ui_accept"):
            next_phrase()

func show_dialog(key, is_intro = false):
	if frame_count == null:
		frame_count = $DialogSprite.frames.get_frame_count($DialogSprite.animation)
	assert(!dialog_visible)
	if STRING_DICT.keys().has(key):
		phrases = STRING_DICT[key]
	elif key == "door-locked":
		phrases = STRING_DICT[key + "-" + str(knock_index)]
		if knock_index < knock_joke_count-1:
			knock_index += 1
	else:
		phrases = ["I don't even know what to say.."] # fallback
	dialog_visible = true
	emit_signal("dialog_started")
	update_dialog_visibilty()
	$DialogSprite.frame = randi() % frame_count
	$DialogLabel.text = phrases[current_phrase]
	if !is_intro:
		AudioPlayer.play_mumble(-1)
		$DialogSprite.animation = "default"
	else:
		$DialogSprite.animation = "intro"
	
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
