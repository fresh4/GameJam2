extends Node
class_name Plot

@export var plant_growth_progress_sprite: Texture2D

@onready var plant_sprite: AnimatedSprite2D = %PlantSprite
@onready var plot_sprite: Sprite2D = $PlotSprite
@onready var pepper_positions: Node2D = %PepperPositions

var sunlight: int = 0 ## How much light is currently shining on the spot
var is_occupied: bool = false ## If this plot is occupied with a plant 
var pepper: Pepper ## Reference to the specific pepper object growing in this plot 
var growth_stage: int = 0 ## The current growth stage of the plant
var is_hovered: bool = false ## If a pepper is hovering over the empty plot
var harvest_yield: int = 0 ## How many peppers does this plant currently have

var pepper_scale_factor: float = 0.4 ## How much to scale down the pepper when on the flower
var flower_points: Array[Node2D] ## List of possible positions to grow peppers on the plant

var pepper_texture: Texture2D
var pepper_scale: Vector2
var pepper_prefab_path: String

func _ready() -> void:
	for node in pepper_positions.get_children():
		flower_points.append(node)

func _input(event: InputEvent) -> void:
	# Plant pepper if released over plot, under certain logical conditions
	if event.is_action_released("click") and is_hovered and pepper and not is_occupied:
		is_occupied = true
		is_hovered = false
		plant_sprite.frame = 1
		pepper_texture = pepper.sprite.texture
		pepper_scale = pepper.sprite.scale
		pepper_prefab_path = pepper.scene_file_path
		pepper.queue_free()
	# Harvest pepper if harvestable
	elif event.is_action_pressed("click") and is_occupied and is_hovered and growth_stage == 3:
		growth_stage = 0
		is_occupied = false
		plant_sprite.frame = 0
		for x in pepper_positions.get_children(): x.queue_free()
		var prefab = load(pepper_prefab_path)
		for idx in harvest_yield:
			var instance: Pepper = prefab.instantiate() as Pepper
			instance.position = Globals.pepper_spawn_point
			Globals.inside.add_child(instance)
			await get_tree().create_timer(0.05).timeout
		# Reset the growth stage to 0 and set is_occupied to false
		# Instantiate a number of peppers equal to the harvest yield of the same pepper type

func progress_growth() -> void:
	var growth_stages_count = plant_sprite.sprite_frames.get_frame_count("default")
	if plant_sprite.frame < growth_stages_count - 1:
		plant_sprite.frame += 1
		growth_stage += 1
	else: return
	# TODO: Depending on certain factors (quality of plant), grow X number of peppers when flowering
	harvest_yield = 2 # Calculate ^, max 3
	if plant_sprite.frame == growth_stages_count - 1:
		for idx in harvest_yield:
			if idx > len(pepper_positions.get_children()): break
			var new_sprite: Sprite2D = Sprite2D.new()
			new_sprite.texture = pepper_texture
			new_sprite.scale = pepper_scale * pepper_scale_factor
			pepper_positions.get_children()[idx - 1].add_child(new_sprite)

func _on_area_2d_body_entered(body: Pepper) -> void:
	pepper = body

func _on_area_2d_body_exited(_body: Pepper) -> void:
	pepper = null

func _on_area_2d_mouse_entered() -> void:
	plot_sprite.material.set_shader_parameter("width", 80)
	is_hovered = true

func _on_area_2d_mouse_exited() -> void:
	plot_sprite.material.set_shader_parameter("width", 0)
	is_hovered = false
