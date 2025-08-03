extends Node

@onready var main_menu: AudioStreamPlayer = $MainMenu
@onready var main_loop: AudioStreamPlayer = $MainGameLoop
@onready var victory_loop: AudioStreamPlayer = $VictoryLoop
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var apple_munch: AudioStreamPlayer = $AppleMunch

var fade_out_tween: Tween
var fade_in_tween: Tween


func _ready() -> void:
	play_main_menu()


func is_menu_playing():
	return main_menu.playing


func play_main_menu():
	main_menu.volume_db = linear_to_db(0.01)
	if fade_in_tween:
		fade_in_tween.kill()
	main_menu.play()
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(main_menu, "volume_db", linear_to_db(1),2)


func stop_main_menu():
	if fade_out_tween:
		fade_out_tween.kill()
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(main_menu,"volume_db",linear_to_db(0.01),2)
	await fade_out_tween.finished
	main_menu.stop()


func play_main_loop():
	main_loop.volume_db = linear_to_db(0.01)
	if fade_in_tween:
		fade_in_tween.kill()
	main_loop.play()
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(main_loop, "volume_db", linear_to_db(1),2)


func stop_main_loop():
	if fade_out_tween:
		fade_out_tween.kill()
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(main_loop,"volume_db",linear_to_db(0.01),2)
	await fade_out_tween.finished
	main_loop.stop()


func start_victory_loop():
	victory_loop.volume_db = linear_to_db(0.01)
	if fade_in_tween:
		fade_in_tween.kill()
	victory_loop.play()
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(victory_loop, "volume_db", linear_to_db(1),2)


func stop_victory_loop():
	if fade_out_tween:
		fade_out_tween.kill()
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(victory_loop,"volume_db",linear_to_db(0.01),2)
	await fade_out_tween.finished
	victory_loop.stop()


func play_game_over():
	game_over.play()
	await game_over.finished
	play_main_menu()


func play_munch():
	apple_munch.play()
