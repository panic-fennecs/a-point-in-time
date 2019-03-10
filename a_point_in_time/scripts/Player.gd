extends Node2D

# TODO correct start pos
var pos = Vector2i.new(0, 0)
var movestate = null # null or MoveState
var is_dialog_open_var = false

var dialog_controller
var animation_sprite
const speed = 5

func _ready():
	$AnimatedSprite.play("bot_stand");
	dialog_controller = get_node("/root/Node2D/PlayerCamera/DialogCanvas")
	dialog_controller.show_dialog("enter-basement")
	animation_sprite = get_node("/root/Node2D/TimeMachine/AnimatedSprite")

func _process(delta):
	check_trigger();
	update_transform();
	update_walk(speed * delta);
	
	if !get_node("/root/Node2D/PlayerCamera/DialogCanvas").dialog_visible:
		is_dialog_open_var = false

func is_closed_door(x, y):
	return x == 7 and y == 12 and get_node("/root/Node2D/Door").is_closed()

func is_solid_tile(x, y):
	var map = $"/root/Node2D/Map";
	return map.has_collider_at(x, y) or is_closed_door(x, y);

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
	if is_dialog_open():
		return false

	if animation_sprite.in_animation():
		return false
	
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
	if Input.is_action_just_pressed("ui_accept") and !is_dialog_open():
		if animation_sprite.in_animation():
			return
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
			var target = vi_plus(pos, to_vec(dir))
			if is_solid_tile_v(target):
				$AnimatedSprite.play(dir_to_string(dir) + "_stand");
				check_clickable(target)
			else:
				movestate = MoveState.new(dir, delta)
				get_node("/root/Node2D/PlayerCamera/ClickableLabel").visible = false
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
			get_node("/root/Node2D/TriggerController").stand_position(pos)
			update_walk(extra_delta);
			if movestate == null and $AnimatedSprite.animation.ends_with("move"):
				$AnimatedSprite.play(dir_to_string(old_dir) + "_stand");

func is_dialog_open():
	if get_node("/root/Node2D/PlayerCamera/DialogCanvas").dialog_visible:
		is_dialog_open_var = true
	return is_dialog_open_var

func move_left():
	movestate = MoveState.new(LEFT, 0)
	$AnimatedSprite.play("left_move")
	
func move_bot():
	movestate = MoveState.new(BOT, 0)
	$AnimatedSprite.play("bot_move")
	
func move_right():
	movestate = MoveState.new(RIGHT, 0)
	$AnimatedSprite.play("right_move")
	
func move_top():
	movestate = MoveState.new(TOP, 0)
	$AnimatedSprite.play("top_move")

func check_clickable(pos):
	get_node("/root/Node2D/PlayerCamera/ClickableLabel").visible = get_node("/root/Node2D/TriggerController").is_clickable(pos.x, pos.y)