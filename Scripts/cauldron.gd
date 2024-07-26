extends Node
class_name Cauldron

const YEET_STRENGTH: int = 750

@onready var ingredients_added_sprites: Node2D = $IngredientsAdded
@onready var mix_button: Button = $MixButton
@onready var animated_splash_sprite: AnimatedSprite2D = %AnimatedSplashSprite
@onready var ingredient_detection_area: Area2D = $IngredientDetectionArea

var ingredients: Array[PepperTemplate]
var ingredients_sprites: Array[Sprite2D]
var max_ingredients: int = 3

func _ready() -> void:
	for sprite in ingredients_added_sprites.get_children():
		ingredients_sprites.append(sprite)
	max_ingredients = len(ingredients_sprites)

func _on_ingredient_detection_area_body_entered(body: RigidBody2D) -> void:
	# Stop momentum to ensure launch
	body.linear_velocity = Vector2.ZERO
	
	# Break the dragging state to disconnect from cursor and ensure launch
	for child in body.get_children():
		if child is DraggableObject:
			child.dragging = false
	
	# If the item is invalid or cauldron is full, YEET the item
	if not body is Pepper or (len(ingredients) >= max_ingredients or not body.properties.is_pepper): 
		body.apply_central_impulse(Vector2(-YEET_STRENGTH * body.mass, -YEET_STRENGTH * body.mass))
		return
	# Add to the current ingredients to track what's in the cauldron
	ingredients.append((body as Pepper).properties)
	if len(ingredients) >= max_ingredients: mix_button.disabled = false
	# Delete the draggable instance of the ingredient
	body.queue_free()
	# Add a sprite of the ingredient to the cauldron for visual keeping track
	ingredients_sprites[len(ingredients) - 1].texture = body.sprite.texture
	ingredients_sprites[len(ingredients) - 1].scale = body.sprite.scale
	animated_splash_sprite.play("default")
	AudioManager.play_random(AudioManager.SFX_SPLASHES)

func arrays_have_same_content(array1, array2):
	if array1.size() != array2.size(): return false
	for item in array1:
		if !array2.has(item): return false
		if array1.count(item) != array2.count(item): return false
	return true

func _on_mix_button_pressed() -> void:
	for sauce in Globals.SAUCES:
		if not arrays_have_same_content(sauce.recipe, ingredients): continue
		if sauce not in Globals.discovered_sauces:
			Globals.game_manager.pay(sauce.value)
			Globals.discovered_sauces.append(sauce)
		
		var new_sauce: Sauce = Globals.SAUCE_PREFAB.instantiate()
		new_sauce.global_position = ingredient_detection_area.global_position
		new_sauce.properties = sauce
		Globals.inside.add_child(new_sauce)
		
		reset_cauldron()
		AudioManager.play_random(AudioManager.SFX_BREWS)
		return
	# If the recipe is invalid
	mix_button.disabled = true
	for i in ingredients:
		var pepper_prefab: Pepper = load(i.path_to_prefab).instantiate()
		pepper_prefab.global_position = ingredient_detection_area.global_position
		Globals.inside.add_child(pepper_prefab)
		await get_tree().create_timer(0.5).timeout
	reset_cauldron()

func reset_cauldron() -> void:
	for idx in len(ingredients):
		ingredients_sprites[idx].texture = null
		ingredients = []
		mix_button.disabled = true
