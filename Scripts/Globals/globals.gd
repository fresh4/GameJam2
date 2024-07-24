extends Node

var PEPPERS: Array[PepperTemplate]
var SAUCE_RECIPES: Array[SauceTemplate]

var discovered_peppers: Array[PepperTemplate] = []
var discovered_sauces: Array[SauceTemplate] = []

var game_manager: GameManager
var outside: Node2D
var inside: Node2D
var pepper_spawn_point: Vector2

func _ready() -> void:
	load_peppers()
	
func load_peppers() -> void:
	var peppers_path = "res://Resources/Peppers/"
	var dir = DirAccess.open(peppers_path)
	dir.list_dir_begin()
	while true:
		var filename = dir.get_next()
		if filename == "": break
		var full_path_to_resource: String = peppers_path.path_join(filename)
		PEPPERS.append(load(full_path_to_resource))

