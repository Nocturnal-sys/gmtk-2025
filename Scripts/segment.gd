class_name Segment
extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

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
					sprite.play("up_down")
				Vector2.LEFT, Vector2.RIGHT:
					sprite.play("left_right")
		else:
			is_corner = true
			match to_follow.direction - direction:
				Vector2(1,1):
					sprite.play("bend_down_l")
				Vector2(-1,1):
					sprite.play("bend_down_r")
				Vector2(1,-1):
					sprite.play("bend_up_l")
				Vector2(-1,-1):
					sprite.play("bend_up_r")
	else:
		is_corner = false
		match to_follow.direction:
			Vector2.UP:
				sprite.play("tail_up")
			Vector2.DOWN:
				sprite.play("tail_down")
			Vector2.LEFT:
				sprite.play("tail_left")
			Vector2.RIGHT:
				sprite.play("tail_right")
