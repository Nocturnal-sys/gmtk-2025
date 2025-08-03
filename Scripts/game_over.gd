extends CanvasLayer

@onready var settlement_label: Label = $SettlementLabel
@onready var food_label: Label = $FoodLabel
@onready var menu_button: Button = $MenuButton
@onready var score_label: Label = $ScoreLabel

var total_food: int
var total_settlement: int
var total_proteced: int
var total_score: int
var displayed_food: int = 0
var displayed_settlement: int = 0
var displayed_score: int = 0
var display_tween: Tween


func _ready() -> void:
	total_food = ScoreKeeper.get_total_eaten()
	total_proteced = ScoreKeeper.get_total_protected()
	total_settlement = ScoreKeeper.get_total_settlements()
	total_score = ScoreKeeper.get_score()
	settlement_label.text = "0/"+str(total_settlement)
	food_label.text = "0"
	_display_scores()


func _process(_delta: float) -> void:
	settlement_label.text = str(displayed_settlement)+"/"+str(total_settlement)
	food_label.text = str(displayed_food)
	score_label.text = str(displayed_score)


func _display_scores():
	display_tween = create_tween()
	display_tween.tween_property(self,"displayed_food",total_food,0.5)
	await display_tween.finished
	display_tween.kill()
	display_tween = create_tween()
	display_tween.tween_property(self,"displayed_settlement",total_proteced,0.5)
	await display_tween.finished
	display_tween.kill()
	display_tween = create_tween()
	display_tween.tween_property(self,"displayed_score",total_score*total_food,4)
	if total_score>0:
		AudioManager.play_score()
	await display_tween.finished
	AudioManager.stop_score()


func _on_menu_button_pressed() -> void:
	if not AudioManager.is_menu_playing():
		AudioManager.stop_victory_loop()
		AudioManager.play_main_menu()
	ScoreKeeper.new_game()
	LevelManager.main_menu()
