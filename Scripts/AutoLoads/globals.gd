extends Node

enum READABLE_TYPE { LETTER }

const SAUCE_PREFAB = preload("res://Prefabs/sauce_prefab.tscn")

const readables: Dictionary = {
	0: "res://Prefabs/Readables/Templates/letter.tscn"
}

var PEPPERS: Array[PepperTemplate]
var SAUCES: Array[SauceTemplate]

var discovered_peppers: Array[PepperTemplate] = []
var discovered_sauces: Array[SauceTemplate] = []

var game_manager: GameManager
var outside: Node2D
var inside: Node2D
var pepper_spawn_point: Vector2

func _ready() -> void:
	load_peppers()
	load_sauces()
	
func load_peppers() -> void:
	var peppers_path = "res://Resources/Peppers/"
	var dir = DirAccess.open(peppers_path)
	dir.list_dir_begin()
	while true:
		var filename = dir.get_next()
		if filename == "": break
		var full_path_to_resource: String = peppers_path.path_join(filename)
		PEPPERS.append(load(full_path_to_resource))

func load_sauces() -> void:
	var sauces_path = "res://Resources/Sauces/"
	var dir = DirAccess.open(sauces_path)
	dir.list_dir_begin()
	while true:
		var filename = dir.get_next()
		if filename == "": break
		var full_path_to_resource: String = sauces_path.path_join(filename)
		SAUCES.append(load(full_path_to_resource))

