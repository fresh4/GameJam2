extends Node
class_name Plot

@export var plant_growth_progress_sprite: Texture2D

@onready var plant_sprite: AnimatedSprite2D = %PlantSprite

var sunlight: int = 0 ## How much light is currently shining on the spot
var is_occupied: bool = false ## If this plot is occupied with a plant 
var pepper: Pepper ## Reference to the specific pepper object growing in this plot 
var growth_stage: int = 0 ## The current growth stage of the plant
var is_hovered: bool = false ## If a pepper is hovering over the empty plot

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and is_hovered:
		is_occupied = true
		is_hovered = false
		#plant_sprite.texture = plant_growth_progress_sprite # Need to store plant sprite values somewhere, maybe a global array/spritesheet
		plant_sprite.frame = 1
		pepper.queue_free()

# TODO:
# When a pepper is dragged onto a plot:
# 1. delete the pepper from the scene tree + 
# 2. set is_occupied to true +
# 3. set `pepper` to be reference to the pepper that was placed + 
# 4. set stage to initial value
# 5. set plant sprite to appropriate value based on growth stage

func progress_growth() -> void:
	if plant_sprite.frame < plant_sprite.sprite_frames.get_frame_count("default"):
		plant_sprite.frame += 1

func _on_area_2d_body_entered(body: Pepper) -> void:
	pepper = body
	is_hovered = true

func _on_area_2d_body_exited(_body: Pepper) -> void:
	pepper = null
	is_hovered = false
