extends Resource
class_name PepperTemplate

# NOTE:
# This template script defines the properties of a custom Pepper Resource
# To make a new pepper, create a new resource with the type 'Pepper Template' and fill out the values
# This template can also be used to create non-peppers for the purpose of making sauces
# ie, 'vinegar' can be a pepper with scoville 0, no recipe, etc.

@export_range(0, 15000000) var max_scoville: int = 1000 ## Maximum potential Scoville value for the pepper
@export_range(0, 100) var required_light: int = 100 ## Optimal light levels for this pepper's growth
@export var sprite: Texture2D  ## Texture to use for this pepper
@export var recipe: Array[PepperTemplate] ## What peppers combined can create this pepper; empty if base pepper
@export var tooltip_text: String = "" ## Description to show in tooltip
@export var is_pepper: bool = true ## Is this object a pepper? No for generic draggable physics objects
