extends Node

var PEPPER_RECIPES = [
	preload("res://Prefabs/Peppers/pepper_green_prefab.tscn"),
	preload("res://Prefabs/Peppers/pepper_red_prefab.tscn")
]

var SAUCE_RECIPES = [
	
]

var outside: Node2D
var inside: Node2D
var pepper_spawn_point: Vector2
