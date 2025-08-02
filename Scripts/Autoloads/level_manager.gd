extends Node
const START_MENU = preload("res://Scenes/Levels/start_menu.tscn")
const GAME_OVER = preload("res://Scenes/game_over.tscn")


func change_scene(next):
	print(next)
	get_tree().call_deferred("change_scene_to_packed", next)


func main_menu():
	get_tree().call_deferred("change_scene_to_packed", START_MENU)


func game_over():
	get_tree().call_deferred("change_scene_to_packed", GAME_OVER)
