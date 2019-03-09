extends CanvasLayer

var dialog_visible
var phrases
var current_phrase = 0
var frame_count

signal dialog_started
signal dialog_finished

	
func _ready():
	frame_count = $DialogSprite.frames.get_frame_count("default")	
	#show_dialog(["Hey", "wie gehts?", "mir gehts gut!"])

func _input(event):
	print()
	if !dialog_visible:
		return
	
	if event is InputEventKey:
        if event.pressed and Input.is_action_just_pressed("ui_accept"):
            next_phrase()

func show_dialog(phrase_list):
	assert(!dialog_visible)
	assert(len(phrase_list) > 0)
	phrases = phrase_list
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
	
	