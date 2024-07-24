extends RigidBody2D
class_name Pepper

@export var properties: PepperTemplate

@onready var tooltip: Label = %Tooltip
@onready var sprite: Sprite2D = %Icon

func _ready() -> void:
	tooltip.text = properties.tooltip_text
	properties.path_to_prefab = scene_file_path
