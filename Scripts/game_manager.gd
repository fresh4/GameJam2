extends Node

const MAX_ROUNDS = 5

@export var gradient_texture: GradientTexture1D

@onready var outside: Node2D = $Outside
@onready var inside: Node2D = $Inside

var current_round: int = 0 ## The time of day, ranges from 0-5
var day: int = 0 ## The current day
var plots: Array[Plot] ## Array of plots on the field
var current_sunlight: int ## Sunlight value, between 1 and 100?
var step: int = 1

func _ready() -> void:
	outside.modulate = gradient_texture.gradient.sample(calculate_gradient_value())
	for plot in %Plots.get_children() as Array[Plot]:
		plots.append(plot)

func progress_time() -> void:
	# TODO: Refactor
	if current_round < MAX_ROUNDS:
		current_round += 1
		#if current_round == 0: step *= -1
	else:
		current_round = 0
		#step *= -1
		day += 1
		#current_round += step
	var value = calculate_gradient_value()
	print("Day: day ", day, " | round: ", current_round, " | gradient light value: ", value)
	var tween = get_tree().create_tween()
	tween.tween_property(outside, "modulate", gradient_texture.gradient.sample(value), 1)

func calculate_gradient_value() -> float:
	var x: float = PI * current_round * (1 / float(MAX_ROUNDS))
	var value = ( sin( x - PI/2 ) + 1.0 ) / 2.0
	return snappedf(value, 0.1)

# WARNING: Temporary debug button to progress time
func _on_button_pressed() -> void:
	for plot in plots:
		if plot.is_occupied:
			plot.progress_growth()
	progress_time()
