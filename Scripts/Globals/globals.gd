extends Node

var PEPPERS: Array[PepperTemplate] = [
	preload("res://Resources/Peppers/black_pepper.tres"),
	preload("res://Resources/Peppers/blue_pepper.tres"),
	preload("res://Resources/Peppers/brown_pepper.tres"),
	preload("res://Resources/Peppers/green_pepper.tres"),
	preload("res://Resources/Peppers/orange_pepper.tres"),
	preload("res://Resources/Peppers/purple_pepper.tres"),
	preload("res://Resources/Peppers/rainbow_pepper.tres"),
	preload("res://Resources/Peppers/red_pepper.tres"),
	preload("res://Resources/Peppers/white_pepper.tres"),
	preload("res://Resources/Peppers/yellow_pepper.tres"),
]

var SAUCE_RECIPES = [
	
]

var outside: Node2D
var inside: Node2D
var pepper_spawn_point: Vector2
