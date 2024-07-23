extends Node

var PEPPERS: Array[PepperTemplate] = [
	preload("res://Resources/Peppers/brown_pepper.tres"),
	preload("res://Resources/Peppers/green_pepper.tres"),
	preload("res://Resources/Peppers/red_pepper.tres")
]

var SAUCE_RECIPES = [
	
]

var outside: Node2D
var inside: Node2D
var pepper_spawn_point: Vector2
