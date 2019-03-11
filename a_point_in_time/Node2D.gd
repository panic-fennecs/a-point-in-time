extends Node2D

func _ready():
	pass

func _process(delta):
	$TextLabelNode.position.y -= delta * 70

func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/StartScreen.tscn")