extends Node2D

func _ready():
	var map = $"/root/Node2D/TileMap"
	print(map.get_cell(0, 0))

func has_collider_at(x, y):
	var map = $"/root/Node2D/TileMap";
	var id = map.get_cell(0, 0);
	var ret = (x == 0 and y == 0) # TODO
	return ret
