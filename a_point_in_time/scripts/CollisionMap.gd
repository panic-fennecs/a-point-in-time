extends Node2D

func _ready():
	var map = $"/root/Node2D/TileMap"
	# print(map.get_cell(0, 0))

func has_collider_by_id(id):
	var ret = false
	if id != -1:
		# TODO extend!
		ret = id == 1
	return ret

func has_collider_at(x, y):
	var map = $"/root/Node2D/TileMap";
	var id = map.get_cell(x, y);
	var ret = has_collider_by_id(id)
	return ret
