extends CanvasLayer

const NEXT = preload("res://Scenes/Levels/level_1.tscn")


func _on_start_button_pressed() -> void:
	LevelManager.change_scene(NEXT)
