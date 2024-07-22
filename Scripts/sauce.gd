extends RigidBody2D
class_name Sauce

@export_range(0,15000000) var scoville: int ## Heat index in Scoville units
@export var recipe: Array[Pepper] ## What peppers combined make this sauce
@export var value: int ## How much this sauce sells for

func _ready() -> void:
	pass # Replace with function body.

