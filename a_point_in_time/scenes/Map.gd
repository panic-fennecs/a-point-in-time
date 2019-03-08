extends Node2D

func _ready():
	var map = $"/root/Node2D/Map/GroundMap"
	print(map.get_cell(16, -2))

func has_collider_by_id(id):
	var ret = false
	if id != -1:
		# TODO extend!
		ret = id == 1
	return ret

func has_collider_at(x, y):
	var map = $"/root/Node2D/Map/GroundMap";
	var id = map.get_cell(x, y);
	var ret = has_collider_by_id(id)
	return ret
