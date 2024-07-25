extends RigidBody2D
class_name Sauce

@export var properties: SauceTemplate

@onready var sauce: Sprite2D = $Sauce

func _ready() -> void:
	var mixed_colors: Color = Color(0,0,0)
	for pepper in properties.recipe:
		mixed_colors = ((pepper.flower_color/len(properties.recipe)) + mixed_colors).clamp()
	sauce.modulate = mixed_colors
