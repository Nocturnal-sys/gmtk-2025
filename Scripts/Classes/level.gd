class_name Level
extends Node2D

@onready var snake_bits: Node2D = $SnakeBits
@onready var head: Head = $SnakeBits/Head
@onready var timer: Timer = $Timer

const APPLE = preload("res://Scenes/apple.tscn")
const SEGMENT = preload("res://Scenes/segment.tscn")
const BODY_STRAIGHT = preload("res://Resources/body_straight.tres")
const TAIL = preload("res://Resources/tail.tres")
const TILE_SIZE = 16

var food : Food
var segment : Segment
var speed : float
var direction : String = "up"
var prev_direction : String = "up"
var dir_dict : Dictionary = {
	"up"    : Vector2.UP,
	"down"  : Vector2.DOWN,
	"left"  : Vector2.LEFT,
	"right" : Vector2.RIGHT
}


func _ready() -> void:
	create_food()
	snake_bits.get_child(-1).set_tail()
	speed = 5
	timer.wait_time = 1/speed
	timer.start()
	_face_direction("up")


func move() -> void:
	_face_direction(direction)
	head.prev_position = head.position
	head.position = head.position + dir_dict[direction] * TILE_SIZE
	for i in snake_bits.get_child_count()-1:
		snake_bits.get_child(i + 1).move()


func _eat(item : Food):
	item.queue_free()
	create_food()
	add_segment()


func create_food() -> void:
	var new_food_pos = Vector2(randi_range(0, 31) * 16, randi_range(0, 31) * 16)
	var space_occupied : bool = false
	for bit in snake_bits.get_children():
		if new_food_pos == bit.position:
			space_occupied = true
			break
	if space_occupied:
		create_food()
	else:
		food = APPLE.instantiate()
		call_deferred("add_child", food)
		food.position = new_food_pos

func add_segment():
	snake_bits.get_child(-1).set_body()
	segment = SEGMENT.instantiate()
	segment.to_follow = snake_bits.get_child(-1)
	segment.position = segment.to_follow.prev_position
	snake_bits.call_deferred("add_child",segment)
	segment.call_deferred("set_tail")


func _on_timer_timeout() -> void:
	move()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("face_up"):
		prev_direction = direction
		direction = "up"
	if event.is_action_pressed("face_down"):
		prev_direction = direction
		direction = "down"
	if event.is_action_pressed("face_left"):
		prev_direction = direction
		direction = "left"
	if event.is_action_pressed("face_right"):
		prev_direction = direction
		direction = "right"


func _face_direction(dir: String) -> void:
	if head.prev_position == head.position + dir_dict[dir]*TILE_SIZE:
		direction = prev_direction
		return
	head.face_direction(dir)
