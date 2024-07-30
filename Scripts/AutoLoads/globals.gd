extends Node

enum READABLE_TYPE { LETTER, JOURNAL }

const RAINBOW_SHADER = preload("res://Shaders/rainbow.gdshader")

const VICTORY_LETTER = "
	You've successfully created the Philosophers Sauce. 
	Unfortunately, it does indeed seem to burn eternally. It seems as 
	though we now need to go after the Philosopher's Ice Cream. 
	
	You don't know anything about churning do you?

	Eternally aflame.
		-The Forever Burning Outrageous Ultra Super Duper Secret 
		Fiery Cabal of Awesome Spicy Chili Connoisseurs
	
	P.S. (Thanks for playing!) <3 - Devs
	"
const RAINBOW_RECIPE_LETTER = preload("res://Assets/Art/Letters/rainbow_recipe_letter.png")

const FLAME_PARTICLES = preload("res://Prefabs/flame_particles.tscn")
const SAUCE_PREFAB = preload("res://Prefabs/sauce_prefab.tscn")
const POINTER = preload("res://Assets/Art/Cursors/hand_point.png")
const HAND_OPEN = preload("res://Assets/Art/Cursors/hand_open.png")
const HAND_CLOSED = preload("res://Assets/Art/Cursors/hand_closed.png")
const DEFAULT = preload("res://Assets/Art/Cursors/pointer_c.png")

var unread_letters: Array = [
	preload("res://Assets/Art/Letters/day_1.png"),
	# Day 2
	"We desire a single potion that burns eternally. -Don't ask why. 
	However this potion is currently outside of our grasp. 
	
	It is up to you to rediscover the recipe. With our help 
	of course, though our production facilities are limited.
	We've attached a recipe of our own design for you to brew. 
	Try it out once you've grown the proper peppers.
	
	WE HAVE SPOKEN!
 		-The Secret Cabal of Chili Connoisseurs
	
	P.S. Careful with these letters by the way. They're awfully
	flammable...",
	# Day 3
	"Your test was a rousing success and the sauce, er, potion that you 
	made has warmed our core most adequately. However such a potion 
	is mere child's play. Your research will lead you to much greater 
	heights. 
	
	Consider making another recipe from our coffers. 
	Do not get complacent, though. To succeed you must contribute your
	own discoveries in kind.

	Thus Sayeth the council.
 		-The Super Secret Cabal of Chili Connoisseurs",
	# Day 4
	"Your concoctions are quite good hermit. We hope you've been
	crossbreeding peppers to get a wider variety of recipes. They
	may be more difficult to grow, but the flavors are well worth it.
	
	We've attached another recipe of ours. Be sure that you're crafting
	these, we gain no research benefit without testing. Your 
	recipes book is a valuable resource. At the very least it doesn't
	catch fire... unlike these letters.

	Warm regards.
		-The Super Duper Secret Cabal of Chili Connoisseurs",
	# Day 5
	"That last sauce was incredible. If you continue in this manner 
	then the philosophers sauce will be ours in no time! 
	
	Try this recipe! We're certain it will be a hit! 
	
	Later, hot stuff.
		-The Ultra Super Duper Secret Cabal of Chili Connoisseurs",
	# Day 6
	"Holy habanero, that stuff is amazing on tacos. Continue what 
	you're doing you madman! This time try mixing this one; we're
	on a roll here!
	
	The guys over at the artic base are loving that recipe, we 
	gotta try it!
	
	Spicy Sendoffs.
		-The Ultra Super Duper Secret Cabal of Awesome Chili 
		Connoisseurs",
	# Day 7
	"Are these getting hotter? That last batch of hot sauce had us 
	chasing cows for some milk. Picture some dark robes chasing 
	after farm animals, you'll laugh for sure! 
	
	Keep up the good work and don't forget that even though you 
	have new peppers, the old ones can provide just as much 
	value to your hot sauce recipes as the fancy new peppers.

	Warmed to the core.
		-The Ultra Super Duper Secret Fiery 
		Cabal of Awesome Chili Connoisseurs",
	# Day 8
	"Send more hot sauce. We must try it. Use more peppers.
	We're reaching the limit of our own research.
	
	*Hiccup*
  		-The Outrageous Ultra Super Duper Secret 
		Fiery Cabal of Awesome Chili Connoisseurs",
	# Day 9
	"Make more fire drink for belly. Taste good, make poops hurt.
	......
	Wethinks we hit block. New recipes up to you now. *hic*
	Enjoy last help.
	
	  -The Outrageous Ultra Super Duper Secret 
	Fiery Cabal of Awesome Spicy Chili Connoisseurs"
]

const readables: Dictionary = {
	0: "res://Prefabs/Readables/Templates/letter.tscn",
	1: "res://Prefabs/Readables/Templates/journal.tscn"
}

var PEPPERS: Array[PepperTemplate]
var SAUCES: Array[SauceTemplate]

var discovered_peppers: Array[PepperTemplate] = []
var discovered_sauces: Array[SauceTemplate] = []
var brewed_sauces: Array[SauceTemplate] = []

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

