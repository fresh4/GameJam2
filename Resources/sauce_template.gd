extends Resource
class_name SauceTemplate

# NOTE:
# This template script defines the properties of a custom Sauce Resource
# A sauce is a combination of various ingredients, including peppers
# To make a new sauce, create a new resource with the type 'Sauce Template' and fill out the values

@export_range(0,15000000) var scoville_value: int = 0 ## Scoville heat value for the sauce
@export var recipe: Array[PepperTemplate] ## Recipe for the sauce. Includes things other than peppers.
@export var sprite: Texture2D ## Sprite to use for this sauce
