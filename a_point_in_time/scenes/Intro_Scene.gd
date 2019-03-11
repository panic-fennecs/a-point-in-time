extends CanvasLayer

var dialog_visible
var phrases = ["stuff", "stuff2"]
var current_phrase = 0
var frame_count = null
var knock_index = 0
var knock_joke_count = 6

signal dialog_started
signal dialog_finished

func _input(event):
	if event is InputEventKey:
        if event.pressed and Input.is_action_just_pressed("ui_accept"):
            next_phrase()
			
func update_dialog_visibilty():
	$DialogLabel.visible = dialog_visible
			
func next_phrase():
	current_phrase += 1
	if current_phrase == len(phrases): # reset
		dialog_visible = false
		emit_signal("dialog_finished")
		current_phrase = 0
		update_dialog_visibilty()
		return

	$DialogLabel.text = phrases[current_phrase]