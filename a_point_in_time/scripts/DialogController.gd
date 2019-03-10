extends CanvasLayer

var dialog_visible
var phrases
var current_phrase = 0
var frame_count

signal dialog_started
signal dialog_finished

const STRING_DICT = {
	"taking-bulb": ["I'm currently taking the bulb", "... wow"],
	"flower": ["This is a pretty flower.", "I like it :)"],
	"plant-future": ["This will take ages to grow..."],
	"plant-present": ["It's gonna be a pretty flower"],
	"take-seed-future": ["It seems nobody needs this seed anymore", "Maybe I'll find a good place for it"],
	"take-seed-present": ["Oh, now I've got that thing again."],
	"dark": ["It's too dark!"]
}

func _ready():
	#print($DialogSprite)
	#show_dialog(["Hey", "wie gehts?", "mir gehts gut!"])
	frame_count = $DialogSprite.frames.get_frame_count("default")

func _input(event):
	if !dialog_visible:
		return
	
	if event is InputEventKey:
        if event.pressed and Input.is_action_just_pressed("ui_accept"):
            next_phrase()

func show_dialog(key):
	assert(!dialog_visible)
	phrases = STRING_DICT[key]
	dialog_visible = true
	emit_signal("dialog_started")
	update_dialog_visibilty()
	$DialogSprite.frame = randi() % frame_count
	$DialogLabel.text = phrases[current_phrase]
	
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
	
	