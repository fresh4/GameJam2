extends RigidBody2D
class_name Pepper

@export var properties: PepperTemplate

#@export var pepper_name: String ## Name/identifier for this pepper
#@export_range(0, 15000000) var max_scoville: int = 1000 ## Maximum potential Scoville value for the pepper
#@export_range(0, 100) var required_light: int = 100 ## Optimal light levels for this pepper's growth
#@export var recipe: Array[Pepper] ## What peppers combined can create this pepper; empty if base pepper
#@export var tooltip_text: String = "" ## Description to show in tooltip
#@export var is_pepper: bool = true ## Is this object a pepper? No for generic draggable physics objects

@onready var tooltip: Label = %Tooltip
@onready var sprite: Sprite2D = %Icon

func _ready() -> void:
	tooltip.text = properties.tooltip_text
	properties.path_to_prefab = scene_file_path
