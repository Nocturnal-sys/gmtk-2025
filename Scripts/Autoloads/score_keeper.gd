extends Node

var score : int = 0
var eaten : int = 0
var total_score : int = 0
var total_eaten : int = 0


func increase_eaten() -> void:
	eaten += 1


func get_eaten() -> int:
	return eaten


func increase_score(num: int) -> void:
	score += num


func get_score() -> int:
	return score


func reset_eaten() -> void:
	total_eaten += eaten
	eaten = 0


func reset_score() -> void:
	total_score += score
	score = 0


func get_total_score() -> int:
	return total_score


func get_total_eaten() -> int:
	return total_eaten
