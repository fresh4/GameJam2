extends Node2D
class_name RecipeCard

@export var sauce_properties: SauceTemplate
@onready var positions: Node2D = $Positions
@onready var check_sprite: Sprite2D = $CheckSprite

var scale_factor: float = 0.6

func _ready() -> void:
	if not sauce_properties: return
	set_sauce(sauce_properties)

func get_recipe() -> Array[PepperTemplate]:
	return sauce_properties.recipe

func set_sauce(sauce: SauceTemplate) -> void:
	sauce_properties = sauce
	if sauce in Globals.brewed_sauces: check_sprite.visible = true
	var position_nodes: Array[Node] = positions.get_children()
	var idx = 0
	for pepper in sauce_properties.recipe:
		var pepper_sprite = Sprite2D.new()
		pepper_sprite.scale *= scale_factor
		pepper_sprite.texture = pepper.pepper_texture
		position_nodes[idx].add_child(pepper_sprite)
		idx += 1
