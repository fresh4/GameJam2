extends Node
class_name Plot

@export var plant_growth_progress_sprite: Texture2D
@export var flower_sprite_texture: Texture2D

@onready var plant_sprite: AnimatedSprite2D = %PlantSprite
@onready var plot_sprite: Sprite2D = $PlotSprite
@onready var pepper_positions: Node2D = %PepperPositions
@onready var flower_positions: Node2D = $FlowerPositions
@onready var particles: CPUParticles2D = $Particles

var is_crossbred: bool = false ## If the plant has been crossbred already
var is_occupied: bool = false ## If this plot is occupied with a plant 
var is_hovered: bool = false ## If a pepper is hovering over the empty plot
var pepper: Pepper ## Reference to the specific pepper object growing in this plot 
var growth_stage: int = 0 ## The current growth stage of the plant
var harvest_yield: int = 2 ## How many peppers does this plant currently have
var rounds_since_growth: int = 0 ## How many rounds has passed since the last growth

var pepper_scale_factor: float = 0.4 ## How much to scale down the pepper when on the flower
var pepper_points: Array[Node2D] ## List of possible positions to grow peppers on the plant
var flower_points: Array[Node2D] ## List of possible positions to grow flowers on the plant

## Storing values for the original pepper placed in the plot
var pepper_properties: PepperTemplate
var pepper_texture: Texture2D 
var pepper_scale: Vector2
var pepper_prefab_path: String
var original_pepper: Pepper

func _ready() -> void:
	for node in pepper_positions.get_children():
		pepper_points.append(node)
	for node in flower_positions.get_children():
		flower_points.append(node)

func _input(event: InputEvent) -> void:
	if not is_hovered: return
	# Plant pepper if released over plot, under certain logical conditions
	if event.is_action_released("click") and pepper and not is_occupied:
		is_occupied = true
		is_hovered = false
		plant_sprite.frame = 1
		pepper_texture = pepper.sprite.texture
		pepper_scale = pepper.sprite.scale
		pepper_prefab_path = pepper.scene_file_path
		original_pepper = load(pepper_prefab_path).instantiate()
		pepper_properties = pepper.properties
		pepper.queue_free()
		AudioManager.play_random(AudioManager.POPS)
	# Harvest pepper if harvestable
	elif event.is_action_pressed("click") and is_occupied and growth_stage == 3:
		growth_stage = 0
		is_occupied = false
		is_crossbred = false
		plant_sprite.frame = 0
		clean_up()
		var prefab = load(pepper_prefab_path)
		var offset: Vector2 = Vector2(50,0)
		for idx in harvest_yield:
			var instance: Pepper = prefab.instantiate() as Pepper
			instance.position = Globals.pepper_spawn_point + idx*offset
			instance.rotation = PI * randf_range(0, 2)
			Globals.inside.add_child(instance)
			AudioManager.play_random(AudioManager.CLICKS)
			await get_tree().create_timer(0.085).timeout
	# Handle crossbreeding if a flowering plant is applied a pepper
	elif event.is_action_released("click") and pepper and is_occupied and growth_stage == 2 and not is_crossbred:
		for pepper_item in Globals.PEPPERS:
			if pepper.properties in pepper_item.recipe and original_pepper.properties in pepper_item.recipe:
				pepper_prefab_path = pepper_item.path_to_prefab
				pepper_texture = pepper_item.pepper_texture
				harvest_yield = 1 # Only yield one pepper of the new pepper if crossbreeding
				for child in flower_points[0].get_children():
					if child is Sprite2D:
						child.modulate = pepper.properties.flower_color
				AudioManager.play_random(AudioManager.POPS)
				pepper.queue_free() # Delete the held pepper
				is_crossbred = true
				break

func progress_growth() -> void:
	if pepper_properties.growth_rate and rounds_since_growth != pepper_properties.growth_rate: 
		rounds_since_growth += 1
		return
	elif not pepper_properties.growth_rate and pepper_properties.growth_times:
		if not Globals.game_manager.current_round in pepper_properties.growth_times:
			return
	var growth_stages_count = plant_sprite.sprite_frames.get_frame_count("default")
	if plant_sprite.frame < growth_stages_count - 1:
		plant_sprite.frame += 1
		growth_stage += 1
		rounds_since_growth = 0
		particles.emitting = true
	else: return

	if harvest_yield > 1:
		harvest_yield = 3 if randi_range(0, 10) <= 0.1 else 2
	if plant_sprite.frame == growth_stages_count - 2:
		add_flower(flower_sprite_texture)
	if plant_sprite.frame == growth_stages_count - 1:
		clean_up()
		for idx in harvest_yield:
			if idx > len(pepper_positions.get_children()) - 1: break
			var new_sprite: Sprite2D = Sprite2D.new()
			new_sprite.texture = pepper_texture
			new_sprite.scale = pepper_scale * pepper_scale_factor
			pepper_positions.get_children()[idx - 1].add_child(new_sprite)

func add_flower(texture: Texture2D) -> void:
	for idx in 2:
		var new_sprite: Sprite2D = Sprite2D.new()
		new_sprite.texture = texture
		new_sprite.modulate = pepper_properties.flower_color
		flower_positions.get_children()[idx - 1].add_child(new_sprite)

func clean_up() -> void:
	for position_node in pepper_positions.get_children():
		for child in position_node.get_children():
			child.queue_free()
	for position_node in flower_positions.get_children():
		for child in position_node.get_children():
			child.queue_free()

func _on_area_2d_body_entered(body: Pepper) -> void:
	pepper = body

func _on_area_2d_body_exited(_body: Pepper) -> void:
	pepper = null

func _on_area_2d_mouse_entered() -> void:
	plot_sprite.material.set_shader_parameter("width", 2)
	is_hovered = true
	if growth_stage == 3:
		Globals.game_manager.tooltips.toggle_hint(0, true, "Harvest")

func _on_area_2d_mouse_exited() -> void:
	plot_sprite.material.set_shader_parameter("width", 0)
	is_hovered = false
	Globals.game_manager.tooltips.toggle_hint(0, false, "")
