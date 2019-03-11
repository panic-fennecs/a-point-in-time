extends Node2D

func _ready():
	$CanvasLayer.get_node("DialogLabel").margin_left = 47
	$CanvasLayer.connect("dialog_finished", self, "on_outro_finished")
	$CanvasLayer.show_dialog("end-sequence", true)
	
func on_outro_finished():
	get_tree().change_scene("res://scenes/CreditScreen.tscn")
	

