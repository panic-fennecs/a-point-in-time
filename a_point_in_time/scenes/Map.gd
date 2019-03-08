extends Node2D

func _ready():
	var map = $"/root/Node2D/Map/GroundMap"
	# print(map.get_cell(0, 0))

func has_collider_by_id(id):
	var ret = false
	if id != -1:
		# TODO extend!
		ret = id == 15
	return ret

func has_collider_at(x, y):
	var map = $"/root/Node2D/Map/GroundMap";
	var id = map.get_cell(x, y);
	var ret = has_collider_by_id(id)
	return ret
