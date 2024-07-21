extends Node

const MAX_ROUNDS = 5

var current_round: int = 0 ## The time of day, ranges from 0-5
var day: int = 0 ## The current day
var plots: Array[Plot]
var current_sunlight: int ## Sunlight value, between 1 and 100?

func _ready() -> void:
	for plot in $Plots.get_children() as Array[Plot]:
		plots.append(plot)

func progress_time() -> void:
	if current_round <= MAX_ROUNDS:
		current_round += 1
	else:
		current_round = 0
		day += 1

# WARNING: Temporary debug button to progress time
func _on_button_pressed() -> void:
	for plot in plots:
		plot.progress_growth()
