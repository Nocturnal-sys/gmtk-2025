class_name Head
extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite2D

var prev_position : Vector2
var direction : Vector2 = Vector2.UP
var next_direction : Vector2 = Vector2.UP

signal eat(item : Food)


func face_direction(dir : String) -> void:
	match dir:
		"up":
			sprite.play("up")
			direction = Vector2.UP
		"down":
			sprite.play("down")
			direction = Vector2.DOWN
		"left":
			sprite.play("left")
			direction = Vector2.LEFT
		"right":
			sprite.play("right")
			direction = Vector2.RIGHT


func _on_area_entered(area: Area2D) -> void:
	if area is Food:
		eat.emit(area)
