extends CanvasLayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_back_button_pressed() -> void:
	LevelManager.close_options_menu()


func _on_sfx_slider_drag_started() -> void:
	AudioManager.play_score()


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	AudioManager.stop_score()
