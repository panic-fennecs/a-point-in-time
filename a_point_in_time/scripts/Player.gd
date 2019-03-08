extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# TODO
func is_solid_tile(x, y):
	return false

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
		
		func _init(dir):
			self.dir = dir
			self.level = 0

# TODO
func is_pressed(Direction): # bool
	return false

# TODO
var pos = Vector2i.new(0, 0)
var movestate = null # null or MoveState

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

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

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	if movestate == null:
		var dir = get_move_dir()
		if dir != null and !is_solid_tile_v(vi_plus(pos, to_vec(movestate.dir))):
			movestate = MoveState(dir)
	else:
		movestate.dir += delta
		if movestate.dir >= 1:
			movestate = null
			pos = vi_plus(pos, to_vec(movestate.dir))