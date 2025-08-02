extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var food_label: Label = $FoodLabel
@onready var menu_button: Button = $MenuButton


func _ready() -> void:
	score_label.text = str(ScoreKeeper.get_total_score())
	food_label.text = str(ScoreKeeper.get_total_eaten())


func _on_menu_button_pressed() -> void:
	ScoreKeeper.new_game()
	LevelManager.main_menu()
