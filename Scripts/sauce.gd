extends RigidBody2D
class_name Sauce

@export var properties: SauceTemplate

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.texture = properties.texture
