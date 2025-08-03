extends Node

var protected : int = 0
var eaten : int = 0
var total_protected : int = 0
var total_eaten : int = 0
var total_score: int = 0

const TOTAL_SETTLEMENTS: int = 45

func increase_eaten() -> void:
	eaten += 1


func get_eaten() -> int:
	return eaten


func increase_protected(num: int) -> void:
	protected += num


func get_protected() -> int:
	return protected


func reset_eaten() -> void:
	total_eaten += eaten
	eaten = 0


func reset_protected() -> void:
	total_protected += protected
	protected = 0


func get_total_protected() -> int:
	return total_protected


func get_total_eaten() -> int:
	return total_eaten


func new_game() -> void:
	total_eaten = 0
	total_protected = 0
	total_score = 0
	reset_eaten()
	reset_protected()


func increase_score(num) -> void:
	total_score += num


func get_score() -> int:
	return total_score


func get_total_settlements() -> int:
	return TOTAL_SETTLEMENTS
