extends Node2D

func _ready():
	$CanvasLayer.show_dialog("intro-sequence", true)
	$CanvasLayer.connect("dialog_finished", self, "on_intro_finished")
	
func on_intro_finished():
	get_tree().change_scene("res://scenes/Main.tscn")