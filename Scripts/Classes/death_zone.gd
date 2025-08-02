class_name DeathZone
extends Area2D

signal game_over()


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(_area : Area2D):
	game_over.emit()
