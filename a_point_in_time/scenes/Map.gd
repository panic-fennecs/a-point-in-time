extends Node2D

var collidable_ids = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

export var is_future_map = false

func _ready():
	var map = $"/root/Node2D/Map/GroundMap"
	# print(map.get_cell(16, -2))

func has_collider_by_id(id):
	var ret = false
	if id != -1:
		# TODO extend!
		if collidable_ids.has(id):
			ret = true
	return ret

func has_collider_at(x, y):
	var map = $"/root/Node2D/Map/GroundMap";
	var id = map.get_cell(x, y);
	var ret = has_collider_by_id(id)
	return ret

func goto_present():
	self.visible = is_future_map

func goto_future():
	self.visible = !is_future_map