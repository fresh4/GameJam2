extends Node
class_name Cauldron

const YEET_STRENGTH: int = 750

@onready var ingredients_added_sprites: Node2D = $IngredientsAdded

var ingredients: Array[Pepper]
var ingredients_sprites: Array[Sprite2D]

func _ready() -> void:
	for sprite in ingredients_added_sprites.get_children():
		ingredients_sprites.append(sprite)

func _process(_delta: float) -> void:
	pass

func _on_ingredient_detection_area_body_entered(body: RigidBody2D) -> void:
	# Stop momentum to ensure launch
	body.linear_velocity = Vector2.ZERO
	
	# Break the dragging state to disconnect from cursor and ensure launch
	for child in body.get_children():
		if child is DraggableObject:
			child.dragging = false
	
	# If the item is invalid or cauldron is full, YEET the item
	if not body is Pepper or (len(ingredients) >= 3 or not body.is_pepper): 
		body.apply_central_impulse(Vector2(-YEET_STRENGTH, -YEET_STRENGTH))
		return
	
	# Add to the current ingredients to track what's in the cauldron
	ingredients.append(body)
	# Delete the draggable instance of the ingredient
	body.queue_free()
	# Add a sprite of the ingredient to the cauldron for visual keeping track
	ingredients_sprites[len(ingredients) - 1].texture = body.sprite.texture
