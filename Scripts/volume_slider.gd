extends HSlider

@onready var label: Label = $Value

@export
var bus_name: String
var bus_index: int


func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _process(delta: float) -> void:
	label.text = str(int(value*100))


func _on_value_changed(value: float) -> void:
	print("value_changed")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
