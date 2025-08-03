class_name Level
extends Node2D

@onready var snake_bits: Node2D = $SnakeBits
@onready var head: Head = $SnakeBits/Head
@onready var timer: Timer = $Timer
@onready var death_zone: DeathZone = $DeathZone
@onready var enclosure: CollisionPolygon2D = $EnclosedArea/Enclosure
@onready var enclosed_area: Area2D = $EnclosedArea
@onready var end_of_level: CanvasLayer = $EndOfLevel
@onready var settlements: Node2D = $Settlements
@onready var obstacles: Node2D = $Obstacles

@export var speed : float = 1.0
@export var next : String

const GAME_OVER = preload("res://Scenes/game_over.tscn")
const APPLE = preload("res://Scenes/apple.tscn")
const SEGMENT = preload("res://Scenes/segment.tscn")
const BODY_STRAIGHT = preload("res://Resources/body_straight.tres")
const TAIL = preload("res://Resources/tail.tres")
const TILE_SIZE = 16

var end_handled: bool
var food : Food
var segment : Segment
var direction : String = "up"
var prev_direction : String = "up"
var next_level
var dir_dict : Dictionary = {
	"up"    : Vector2.UP,
	"down"  : Vector2.DOWN,
	"left"  : Vector2.LEFT,
	"right" : Vector2.RIGHT
}


func _ready() -> void:
	AudioManager.play_main_loop()
	end_handled = false
	next_level = load(next)
	death_zone.area_exited.connect(game_over)
	create_food()
	snake_bits.get_child(-1).set_tail()
	timer.wait_time = 1/speed
	await get_tree().create_timer(2).timeout
	timer.start()
	_face_direction("up")
	for rock in obstacles.get_children():
		rock.area_entered.connect(_on_rock_area_entered)
	for settlement in settlements.get_children():
		settlement.area_entered.connect(_on_rock_area_entered)


func move() -> void:
	_face_direction(direction)
	head.prev_position = head.position
	head.position = head.position + dir_dict[direction] * TILE_SIZE
	for i in snake_bits.get_child_count()-1:
		snake_bits.get_child(i + 1).move()


func _eat(item : Food):
	AudioManager.play_munch()
	ScoreKeeper.increase_eaten()
	item.queue_free()
	create_food()
	add_segment()


func create_food() -> void:
	var new_food_pos = Vector2(randi_range(1, 30) * 16, randi_range(1, 30) * 16)
	var space_occupied : bool = false
	var settlement_pos: Vector2
	for bit in snake_bits.get_children():
		if new_food_pos == bit.global_position:
			space_occupied = true
			break
	for settlement in settlements.get_children():
		settlement_pos = settlement.global_position
		match settlement.get_class():
			Tent:
				for i in 1:
					for j in 1:
						if new_food_pos == Vector2(settlement_pos.x+(i*16),
						settlement_pos.y+(j*16)):
							space_occupied = true
			House:
				for i in 1:
					for j in 2:
						if new_food_pos == Vector2(settlement_pos.x+(i*16),
						settlement_pos.y+(j*16)):
							space_occupied = true
			Castle:
				for i in 2:
					for j in 3:
						if new_food_pos == Vector2(settlement_pos.x+(i*16),
						settlement_pos.y+(j*16)):
							space_occupied = true
	for obstacle in obstacles.get_children():
		if new_food_pos == obstacle.global_position:
			space_occupied = true
	if space_occupied:
		create_food()
		return
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


func finish_level():
	if end_handled:
		return
	var snake_points = PackedVector2Array()
	for bit in snake_bits.get_children():
		if bit is Head or bit.is_corner == true:
			snake_points.append(bit.global_position)
	enclosure.call_deferred("set_polygon",snake_points)
	await get_tree().create_timer(1/(speed*2)).timeout
	call_deferred("_process_end_of_level")


func _process_end_of_level():
	var enclosed_areas: Array[Area2D] = enclosed_area.get_overlapping_areas()
	var num: int = 0
	var score: int = 0
	for area in enclosed_areas:
		if area is Settlement:
			num += 1
			match area.get_class():
				Tent:
					score += 5
				House:
					score += 20
				Castle:
					score += 50
	if num == 0:
		game_over(head)
		end_handled = true
	else:
		get_tree().paused = true
		AudioManager.stop_main_loop()
		AudioManager.start_victory_loop()
		ScoreKeeper.increase_protected(num)
		ScoreKeeper.increase_score(score)
		end_of_level.show()
		end_handled = true


func game_over(area : Area2D):
	if end_handled:
		return
	if area is Head:
		get_tree().paused = false
		ScoreKeeper.reset_eaten()
		ScoreKeeper.reset_protected()
		LevelManager.game_over()


func _advance_level() -> void:
	AudioManager.stop_victory_loop()
	LevelManager.change_scene(next_level)
	get_tree().paused = false
	ScoreKeeper.reset_eaten()
	ScoreKeeper.reset_protected()
	


func _on_rock_area_entered(area: Area2D) -> void:
	if area is Head:
		game_over(area)
