extends Node2D
# collidable_ids = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
var non_collidable_ids = [0]

export var is_future_map = false

func _ready():
	var map = $"/root/Node2D/Map/GroundMap"
	# print(map.get_cell(16, -2))

func has_collider_by_id(id):
	return !non_collidable_ids.has(id)

func has_collider_at(x, y):
	var gmap = $"/root/Node2D/Map/GroundMap";
	var imap = $"/root/Node2D/Map/ItemMap";
	var id = gmap.get_cell(x, y);
	var ret = has_collider_by_id(id) or imap.get_cell(x, y) >= 0
	return ret

func goto_present():
	self.visible = is_future_map

func goto_future():
	self.visible = !is_future_map
