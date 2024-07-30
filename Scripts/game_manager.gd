extends Node
class_name GameManager

const MAIL = preload("res://Prefabs/mail.tscn")

const MAX_ROUNDS = 6
const RESEARCH_THRESHOLD = 50 ## How many points are needed before the final recipe is automatically discovered

@export var gradient_texture: GradientTexture1D
@export var inside_gradient_texture: GradientTexture1D
@export var pepper_spawn_point: Node2D
@export var coin_prefab: PackedScene
@export var candles: Array[Candle]

@onready var outside: Node2D = $Outside
@onready var inside: Node2D = $Inside
@onready var daynight_gradient: Sprite2D = %DaynightGradient
@onready var button: Button = %Button
@onready var calendar_label: Label = %CalendarLabel
@onready var market: Shop = %Market
@onready var tooltips: Hint = %Tooltips
@onready var research_point_counter_label: Label = %ResearchPointCounterLabel

var wage: int = 1 ## How much gold to pay per day
var current_round: int = 0 ## The time of day, ranges from 0-6
var day: int = 0 ## The current day
var plots: Array[Plot] ## Array of plots on the field
var current_sunlight: int ## Sunlight value, between 1 and 100?
var progress_delay: int = 2 ## Time in seconds to run the time change animation
var shop_opened: bool = false ## The state of the shop's summoned status
var research_points: int = 0
var rainbow_sauce: SauceTemplate = null

func _ready() -> void:
	Globals.discovered_sauces.append(Globals.SAUCES[0])
	#Globals.discovered_sauces = Globals.SAUCES # Debug
	Globals.game_manager = self
	Globals.outside = outside
	Globals.inside = inside
	Globals.pepper_spawn_point = pepper_spawn_point.position
	add_research_points(0)
	outside.modulate = gradient_texture.gradient.sample(calculate_gradient_value())
	calendar_label.text = "0"
	for plot in %Plots.get_children() as Array[Plot]:
		plots.append(plot)

func progress_time() -> void:
	if current_round < MAX_ROUNDS - 1:
		current_round += 1
	else:
		current_round = 0
		day += 1
		handle_new_day()
	
	if current_round >= MAX_ROUNDS - 2:
		for candle in candles: candle.light()
	else: for candle in candles: candle.light(false)
	
	var value = calculate_gradient_value()
	var radians = (PI * current_round * (1 / float(MAX_ROUNDS)))
	
	if daynight_gradient.rotation >= 2 * PI: daynight_gradient.rotation = 0
	if current_round == 0: radians = 2 * PI
	
	print("Day: day ", day, " | round: ", current_round, " | gradient light value: ", value)
	
	button.disabled = true
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(outside, "modulate", gradient_texture.gradient.sample(value), progress_delay).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(inside, "modulate", inside_gradient_texture.gradient.sample(value), progress_delay).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(daynight_gradient, "rotation", radians, progress_delay).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	button.disabled = false

@warning_ignore("integer_division")
func handle_new_day() -> void:
	# Set the calendar to match the current new day
	calendar_label.text = str(day)
	
	# Spawn a number of coins equal to the value of the wage
	pay(wage)
	
	# Spawn a letter for the day, every other day
	if research_points >= RESEARCH_THRESHOLD and not rainbow_sauce:
		for sauce in Globals.SAUCES:
			if sauce.is_rainbow: rainbow_sauce = sauce
			Globals.discovered_sauces.append(rainbow_sauce)
		# TODO: Empty the unread letters and use the special 'final' letter. Current is placeholder
		generate_letter(Globals.RAINBOW_RECIPE_LETTER, rainbow_sauce)
	elif day % 3 == 0 or day == 1: # If the day is divisble by 3 (every three days)
		print(day, " ", day % 3)
		if not Globals.unread_letters: return
		# Choose a sauce to reveal at random
		var undiscovered_recipes: Array[SauceTemplate] = []
		for sauce in Globals.SAUCES:
			if sauce not in Globals.discovered_sauces:
				undiscovered_recipes.append(sauce)
		
		var chosen_sauce: SauceTemplate = undiscovered_recipes.pick_random() as SauceTemplate
		while chosen_sauce.is_rainbow: chosen_sauce = undiscovered_recipes.pick_random() as SauceTemplate
		#add_research_points(chosen_sauce.research_value)
		
		# Generate the letter
		generate_letter(Globals.unread_letters[0], chosen_sauce)
		Globals.unread_letters.pop_front()

func pay(amount: int) -> void:
	for idx in amount:
		# TODO: Set position equal to some node where coins will spawn?
		var coin_node: Node2D = coin_prefab.instantiate() as Node2D
		coin_node.position = Vector2(640, 450)
		coin_node.position.y -= idx * 20 
		inside.add_child(coin_node)
		await get_tree().create_timer(0.1).timeout

func calculate_gradient_value() -> float:
	var x: float = PI * current_round * (1 / float(MAX_ROUNDS))
	var value = ( sin( x - PI/2 ) + 1.0 ) / 2.0
	return snappedf(value, 0.1)

func generate_letter(letter_texture, attached_sauce: SauceTemplate = null) -> void:
	var letter = MAIL.instantiate()
	var readable: ReadableArea = null
	for child in letter.get_children(): if child is ReadableArea: readable = child
	
	letter.set_collision_layer_value(8, true)
	letter.position = Vector2(640, 360)
	readable.properties = ReadableTemplate.new()
	if letter_texture is Resource:
		readable.properties.texture = letter_texture
	elif letter_texture is String:
		readable.properties.content = letter_texture
	if attached_sauce:
		readable.properties.has_recipe = true
		readable.properties.sauce = attached_sauce
	if attached_sauce:
		Globals.discovered_sauces.append(attached_sauce)
	Globals.game_manager.tooltips.discovered_recipe()
	
	inside.add_child(letter)
	AudioManager.play_audio(AudioManager.MAIL_CHIME)

func add_research_points(value: int) -> void:
	research_points += value
	research_point_counter_label.text = str(research_points) + "/50"

func _on_button_pressed() -> void:
	progress_time()
	for plot in plots:
		if plot.is_occupied:
			plot.progress_growth()
