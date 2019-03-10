extends Node2D

enum TresorNoteState {
	START,
	NOTE_IN_INV,
	OPENED,
}

var tresor_note_state = START
var note_item_scene = preload("res://scenes/NoteItem.tscn")
var note_item = null
var dialog_controller

func _ready():
	get_node("/root/Node2D/TriggerController").add_trigger(self);
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")

func trigger():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if tresor_note_state == START and fut:
		dialog_controller.show_dialog("note-in-inventory")
		tresor_note_state = NOTE_IN_INV
		_add_note_item()
	if tresor_note_state == NOTE_IN_INV and !fut:
		dialog_controller.show_dialog("open-safe")
		tresor_note_state = OPENED
		get_node("/root/Node2D/ModuleManager").take_module()
	if tresor_note_state == START and !fut:
		dialog_controller.show_dialog("locked-safe")
	_update()

func _add_note_item():
	note_item = note_item_scene.instance()
	add_child(note_item)

func _update():
	var fut = get_node("/root/Node2D/TimeController").is_future()
	if fut:
		if tresor_note_state == START:
			$AnimatedSprite.play("open")
		elif tresor_note_state == NOTE_IN_INV:
			$AnimatedSprite.play("open")
		elif tresor_note_state == OPENED:
			$AnimatedSprite.play("open")
	else:
		if tresor_note_state == START:
			$AnimatedSprite.play("closed")
		elif tresor_note_state == NOTE_IN_INV:
			$AnimatedSprite.play("closed")
		elif tresor_note_state == OPENED:
			$AnimatedSprite.play("open")

func goto_future():
	_update()

func goto_present():
	_update()