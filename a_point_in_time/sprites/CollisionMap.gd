extends Node2D

func _ready():
	var map = $"/root/Node2D/TileMap"
	print(map.get_cell(0, 0))