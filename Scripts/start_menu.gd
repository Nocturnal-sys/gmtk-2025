extends CanvasLayer

const NEXT = preload("res://Scenes/Levels/level_1.tscn")
const RULES = preload("res://Scenes/rules.tscn")


func _ready() -> void:
	#AudioManager.play_main_menu()
	pass


func _on_start_button_pressed() -> void:
	LevelManager.change_scene(NEXT)
	AudioManager.stop_main_menu()


func _on_rules_button_pressed() -> void:
	LevelManager.change_scene(RULES)


func _on_options_button_pressed() -> void:
	LevelManager.options_menu()
