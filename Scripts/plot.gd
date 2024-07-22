extends Node
class_name Plot

@export var plant_growth_progress_sprite: Texture2D

@onready var plant_sprite: AnimatedSprite2D = %PlantSprite
@onready var pepper_positions: Node2D = %PepperPositions


var sunlight: int = 0 ## How much light is currently shining on the spot
var is_occupied: bool = false ## If this plot is occupied with a plant 
var pepper: Pepper ## Reference to the specific pepper object growing in this plot 
var growth_stage: int = 0 ## The current growth stage of the plant
var is_hovered: bool = false ## If a pepper is hovering over the empty plot

var pepper_scale_factor: float = 0.4 ## How much to scale down the pepper when on the flower
var flower_points: Array[Node2D] ## List of possible positions to grow peppers on the plant

var pepper_texture: Texture2D
var pepper_scale: Vector2

func _ready() -> void:
	for node in pepper_positions.get_children():
		flower_points.append(node)

func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and is_hovered and pepper:
		is_occupied = true
		is_hovered = false
		plant_sprite.frame = 1
		pepper_texture = pepper.sprite.texture
		pepper_scale = pepper.sprite.scale
		pepper.queue_free()

# TODO:
# When a pepper is dragged onto a plot:
# 1. delete the pepper from the scene tree + 
# 2. set is_occupied to true +
# 3. set `pepper` to be reference to the pepper that was placed + 
# 4. set stage to initial value
# 5. set plant sprite to appropriate value based on growth stage

func progress_growth() -> void:
	var growth_stages_count = plant_sprite.sprite_frames.get_frame_count("default")
	if plant_sprite.frame < growth_stages_count:
		plant_sprite.frame += 1
	else: return
	# TODO: Depending on certain factors (quality of plant), grow X number of peppers when flowering
	var number_of_peppers = 2 # Calculate ^, max 3
	if plant_sprite.frame == growth_stages_count - 1:
		for idx in number_of_peppers:
			if idx > len(pepper_positions.get_children()): break
			var new_sprite: Sprite2D = Sprite2D.new()
			new_sprite.texture = pepper_texture
			new_sprite.scale = pepper_scale * pepper_scale_factor
			pepper_positions.get_children()[idx - 1].add_child(new_sprite)

func _on_area_2d_body_entered(body: Pepper) -> void:
	pepper = body
	is_hovered = true

func _on_area_2d_body_exited(_body: Pepper) -> void:
	pepper = null
	is_hovered = false
