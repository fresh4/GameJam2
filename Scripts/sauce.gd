extends RigidBody2D
class_name Sauce

const RAINBOW_SHADER = preload("res://Shaders/rainbow.gdshader")

@export var properties: SauceTemplate

@onready var sauce: Sprite2D = $Sauce
func _ready() -> void:
	var mixed_colors: Color = Color(0,0,0)
	for pepper in properties.recipe:
		mixed_colors = ((pepper.flower_color/len(properties.recipe)) + mixed_colors).clamp()
	sauce.modulate = mixed_colors
	if properties.is_rainbow:
		sauce.material = ShaderMaterial.new()
		sauce.material.shader = RAINBOW_SHADER
		sauce.material.set_shader_parameter("angle", 70)
