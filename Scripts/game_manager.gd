extends Node
class_name GameManager

const MAIL = preload("res://Prefabs/mail.tscn")

const MAX_ROUNDS = 6

@export var gradient_texture: GradientTexture1D
@export var pepper_spawn_point: Node2D
@export var coin_prefab: PackedScene

@onready var outside: Node2D = $Outside
@onready var inside: Node2D = $Inside
@onready var daynight_gradient: Sprite2D = %DaynightGradient
@onready var button: Button = %Button
@onready var calendar_label: Label = %CalendarLabel
@onready var market: Shop = %Market
@onready var tooltips: Hint = %Tooltips

var wage: int = 1 ## How much gold to pay per day
var current_round: int = 0 ## The time of day, ranges from 0-6
var day: int = 0 ## The current day
var plots: Array[Plot] ## Array of plots on the field
var current_sunlight: int ## Sunlight value, between 1 and 100?
var progress_delay: int = 3 ## Time in seconds to run the time change animation

func _ready() -> void:
	#handle_new_day()
	Globals.discovered_sauces.append(Globals.SAUCES[0])
	Globals.game_manager = self
	Globals.outside = outside
	Globals.inside = inside
	Globals.pepper_spawn_point = pepper_spawn_point.position
	outside.modulate = gradient_texture.gradient.sample(calculate_gradient_value())
	calendar_label.text = "0"
	for plot in %Plots.get_children() as Array[Plot]:
		plots.append(plot)

func progress_time() -> void:
	if current_round < MAX_ROUNDS:
		current_round += 1
	else:
		current_round = 0
		day += 1
		handle_new_day()
	
	var value = calculate_gradient_value()
	var radians = (PI * current_round * (1 / float(MAX_ROUNDS)))
	
	if daynight_gradient.rotation >= 2 * PI: daynight_gradient.rotation = 0
	if current_round == 0: radians = 2 * PI
	
	print("Day: day ", day, " | round: ", current_round, " | gradient light value: ", value)
	
	button.disabled = true
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(outside, "modulate", gradient_texture.gradient.sample(value), progress_delay).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(daynight_gradient, "rotation", radians, progress_delay).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	button.disabled = false

@warning_ignore("integer_division")
func handle_new_day() -> void:
	# Set the calendar to match the current new day
	calendar_label.text = str(day)
	
	wage = 1 + len(Globals.discovered_sauces) / 2
	
	# Spawn a number of coins equal to the value of the wage
	for idx in wage:
		# TODO: Set position equal to some node where coins will spawn?
		var coin_node: Node2D = coin_prefab.instantiate() as Node2D
		coin_node.position = Vector2(640, 450)
		coin_node.position.y -= idx * 20 
		inside.add_child(coin_node)
		await get_tree().create_timer(0.1).timeout
	
	# Spawn a letter for the day
	if day % 2:
		# Choose a sauce to reveal at random
		var undiscovered_recipes: Array[SauceTemplate] = []
		for sauce in Globals.SAUCES:
			if sauce not in Globals.discovered_sauces:
				undiscovered_recipes.append(sauce)
		
		var chosen_sauce: SauceTemplate = undiscovered_recipes.pick_random() as SauceTemplate
		
		# Generate the letter
		var letter = MAIL.instantiate()
		var readable: ReadableArea = null
		for child in letter.get_children(): if child is ReadableArea: readable = child
		
		letter.position = Vector2(640, 360)
		readable.properties = ReadableTemplate.new()
		readable.properties.texture = Globals.unread_letters[0]
		readable.properties.has_recipe = true
		readable.properties.sauce = chosen_sauce
		Globals.discovered_sauces.append(chosen_sauce)
		Globals.unread_letters.pop_front()
		
		inside.add_child(letter)

func calculate_gradient_value() -> float:
	var x: float = PI * current_round * (1 / float(MAX_ROUNDS))
	var value = ( sin( x - PI/2 ) + 1.0 ) / 2.0
	return snappedf(value, 0.1)

# WARNING: Temporary debug button to progress time
func _on_button_pressed() -> void:
	progress_time()
	for plot in plots:
		if plot.is_occupied:
			plot.progress_growth()
