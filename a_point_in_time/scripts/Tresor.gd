
extends Node2D

enum TresorNoteState {
	START,
	NOTE_IN_INV,
	OPENED,
}

var tresor_note_state = START

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);

func trigger():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if tresor_note_state == START and fut:
		print("got note!")
		tresor_note_state = NOTE_IN_INV
	if tresor_note_state == NOTE_IN_INV and !fut:
		print("opened tresor!")
		tresor_note_state = OPENED
		$AnimatedSprite.play("open")

func goto_future():
	$AnimatedSprite.play("open")

func goto_present():
	if tresor_note_state != OPENED:
		$AnimatedSprite.play("closed")