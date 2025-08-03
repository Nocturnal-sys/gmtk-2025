extends Node
const START_MENU = preload("res://Scenes/Levels/start_menu.tscn")
const GAME_OVER = preload("res://Scenes/game_over.tscn")
const OPTIONS_MENU = preload("res://Scenes/options_menu.tscn")

func change_scene(next):
	get_tree().call_deferred("change_scene_to_packed", next)


func main_menu():
	get_tree().call_deferred("change_scene_to_packed", START_MENU)


func game_over():
	AudioManager.stop_main_loop()
	AudioManager.play_game_over()
	get_tree().call_deferred("change_scene_to_packed", GAME_OVER)


func options_menu():
	get_tree().paused = true
	get_tree().root.add_child(OPTIONS_MENU.instantiate())


func close_options_menu():
	get_tree().root.get_child(-1).queue_free()
	get_tree().paused = false
