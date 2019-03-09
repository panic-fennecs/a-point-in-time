extends Node2D

# TODO correct start pos
var pos = Vector2i.new(0, 0)
var movestate = null # null or MoveState

func is_solid_tile(x, y):
	var map = $"/root/Node2D/Map";
	return map.has_collider_at(x, y);

func is_solid_tile_v(v):
	return is_solid_tile(v.x, v.y)

class Vector2i:
	var x # int
	var y # int
	
	func _init(x, y):
		self.x = x
		self.y = y
	
func vi_plus(a, b):
	return Vector2i.new(a.x + b.x, a.y + b.y)

enum Direction { LEFT, BOT, RIGHT, TOP }

func to_vec(dir):
	if dir == LEFT:
		return Vector2i.new(-1, 0)
	elif dir == BOT:
		return Vector2i.new(0, 1)
	elif dir == RIGHT:
		return Vector2i.new(1, 0)
	elif dir == TOP:
		return Vector2i.new(0, -1)
	else:
		assert(false)

class MoveState:
		var dir # Direction
		var level # float from 0 to 1
		
		func _init(dir, level):
			self.dir = dir
			self.level = level

func is_pressed(dir): # bool
	if dir == LEFT:
		return Input.is_action_pressed("ui_left")
	elif dir == BOT:
		return Input.is_action_pressed("ui_down")
	elif dir == RIGHT:
		return Input.is_action_pressed("ui_right")
	elif dir == TOP:
		return Input.is_action_pressed("ui_up")
	else:
		assert(false)


func _ready():
	$AnimatedSprite.play("bot_stand");

func get_move_dir():
		if is_pressed(LEFT):
			return LEFT
		elif is_pressed(BOT):
			return BOT
		elif is_pressed(RIGHT):
			return RIGHT
		elif is_pressed(TOP):
			return TOP
		else:
			return null

func dir_to_string(dir):
	if dir == LEFT:
		return "left"
	elif dir == BOT:
		return "bot"
	elif dir == RIGHT:
		return "right"
	elif dir == TOP:
		return "top"
	else:
		assert(false)

func update_transform():
	if movestate == null:
		position.x = pos.x * 64;
		position.y = pos.y * 64;
	else:
		var level = movestate.level;
		var dirv = to_vec(movestate.dir);
		position.x = (pos.x + level * dirv.x) * 64;
		position.y = (pos.y + level * dirv.y) * 64;

func check_trigger():
	var offset = null
	if Input.is_action_just_pressed("ui_accept"):
		var a = $AnimatedSprite.animation;
		if a.begins_with("left"):
			offset = Vector2i.new(-1, 0)
		elif a.begins_with("bot"):
			offset = Vector2i.new(0, 1)
		elif a.begins_with("right"):
			offset = Vector2i.new(1, 0)
		elif a.begins_with("top"):
			offset = Vector2i.new(0, -1)
		else:
			assert(false)
		var p = vi_plus(pos, offset)
		get_node("/root/Node2D/TriggerController").click_position(p)

func update_walk(delta):
	if movestate == null:
		var dir = get_move_dir()
		if dir != null:
			if is_solid_tile_v(vi_plus(pos, to_vec(dir))):
				$AnimatedSprite.play(dir_to_string(dir) + "_stand");
			else:
				movestate = MoveState.new(dir, delta)
				var v = dir_to_string(dir) + "_move";
				if $AnimatedSprite.animation != v:
					$AnimatedSprite.play(v);
	else:
		movestate.level += delta
		if movestate.level >= 1:
			var extra_delta = movestate.level - 1
			var old_dir = movestate.dir
			pos = vi_plus(pos, to_vec(movestate.dir))
			movestate = null
			update_walk(extra_delta);
			if movestate == null and $AnimatedSprite.animation.ends_with("move"):
				$AnimatedSprite.play(dir_to_string(old_dir) + "_stand");
func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var speed = 2
	check_trigger();
	update_transform();
	update_walk(speed * delta);