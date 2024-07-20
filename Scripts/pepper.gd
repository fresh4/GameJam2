@tool
extends RigidBody2D
class_name Pepper

@export_range(0, 15000000) var max_scoville: int = 1000 ## Maximum potential Scoville value for the pepper
@export_range(0, 100) var required_light: int = 100 ## Optimal light levels for this pepper's growth
@export var recipe: Array[PepperTemplate] ## What peppers combined can create this pepper; empty if base pepper
@export var tooltip_text: String = "" ## Description to show in tooltip
@export var is_pepper: bool = true ## Is this object a pepper? No for generic draggable physics objects
@export var sprite_texture: Texture2D : set = editor_set_sprite ## Texture to use for this pepper

@onready var tooltip: Label = %Tooltip
@onready var sprite: Sprite2D = %Icon

func _ready() -> void:
	tooltip.text = tooltip_text
	if sprite_texture:
		sprite.texture = sprite_texture

func editor_set_sprite(value: Texture2D) -> void:
	sprite.texture = value
