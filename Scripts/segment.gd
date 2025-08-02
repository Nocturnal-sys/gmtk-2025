class_name Segment
extends Area2D

const TAIL_UP = preload("res://Resources/tail.tres")
const BODY_UP_DOWN = preload("res://Resources/body_straight.tres")
const BODY_SIDEWAYS = preload("res://Resources/body_sideways.tres")
const BODY_BEND_DOWN_L = preload("res://Resources/body_bend_down_l.tres")
const BODY_BEND_DOWN_R = preload("res://Resources/body_bend_down_r.tres")
const BODY_BEND_UP_L = preload("res://Resources/body_bend_up_l.tres")
const BODY_BEND_UP_R = preload("res://Resources/body_bend_up_r.tres")
const TAIL_DOWN = preload("res://Resources/tail_down.tres")
const TAIL_LEFT = preload("res://Resources/tail_left.tres")
const TAIL_RIGHT = preload("res://Resources/tail_right.tres")


@onready var sprite: Sprite2D = $Sprite2D

@export var to_follow : Area2D

var is_corner: bool = false
var prev_position : Vector2
var tail : bool = false
var direction : Vector2 = Vector2.UP
var prev_direction : Vector2 = Vector2.UP

func _ready() -> void:
	if not tail:
		set_body()

func set_tail() -> void:
	tail = true
	change_sprite_direction()


func set_body() -> void:
	tail = false
	change_sprite_direction()


func move() -> void:
	prev_position = position
	prev_direction = direction
	position = to_follow.prev_position
	direction = (position - prev_position).normalized()
	change_sprite_direction()


func change_sprite_direction():
	if not tail:
		if direction == to_follow.direction:
			is_corner = false
			match direction:
				Vector2.UP, Vector2.DOWN:
					sprite.texture = BODY_UP_DOWN
				Vector2.LEFT, Vector2.RIGHT:
					sprite.texture = BODY_SIDEWAYS
		else:
			is_corner = true
			match to_follow.direction - direction:
				Vector2(1,1):
					sprite.texture = BODY_BEND_DOWN_L
				Vector2(-1,1):
					sprite.texture = BODY_BEND_DOWN_R
				Vector2(1,-1):
					sprite.texture = BODY_BEND_UP_L
				Vector2(-1,-1):
					sprite.texture = BODY_BEND_UP_R
	else:
		is_corner = false
		match to_follow.direction:
			Vector2.UP:
				sprite.texture = TAIL_UP
			Vector2.DOWN:
				sprite.texture = TAIL_DOWN
			Vector2.LEFT:
				sprite.texture = TAIL_LEFT
			Vector2.RIGHT:
				sprite.texture = TAIL_RIGHT
