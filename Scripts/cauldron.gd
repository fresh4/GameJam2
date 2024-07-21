extends Node
class_name Cauldron

@onready var ingredients_added_sprites: Node2D = $IngredientsAdded

var ingredients: Array[Pepper]
var ingredients_sprites: Array[Sprite2D]

func _ready() -> void:
	for sprite in ingredients_added_sprites.get_children():
		ingredients_sprites.append(sprite)

func _process(_delta: float) -> void:
	pass

func _on_ingredient_detection_area_body_entered(body: Pepper) -> void:
	if len(ingredients) >= 3 or not body.is_pepper:
		body.apply_central_impulse(Vector2(-1000, -1000))
		return
	ingredients.append(body)
	body.queue_free()
	# We want a reference to the current ingredients ui element
	# When a pepper is placed in the cauldron, show the pepper on it to see what has been added
	ingredients_sprites[len(ingredients) - 1].texture = body.sprite.texture
