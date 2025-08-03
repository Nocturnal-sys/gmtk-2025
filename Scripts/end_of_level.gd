extends CanvasLayer

@onready var food_label: Label = $ColorRect/FoodLabel
@onready var settlement_label: Label = $ColorRect/SettlementLabel

signal go_next()


func _on_next_level_button_pressed() -> void:
	go_next.emit()
	hide()


func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
	food_label.text = str(ScoreKeeper.get_eaten())
	settlement_label.text = str(ScoreKeeper.get_protected())
