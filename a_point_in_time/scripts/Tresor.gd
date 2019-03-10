
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
	print("tresor und so")

func goto_future():
	$AnimatedSprite.play("open")

func goto_present():
	if tresor_note_state != OPENED:
		$AnimatedSprite.play("closed")