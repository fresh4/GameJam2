extends Readable
class_name Journal

const RECIPE_CARD = preload("res://Prefabs/recipe_card.tscn")

@onready var background: ColorRect = %Background
@onready var overlay: Sprite2D = %Overlay
@onready var grid: GridContainer = $CanvasLayer/Overlay/GridContainer

func _ready() -> void:
	background.color.a = 0
	overlay.position.y = 1440
	
	# Fill with all the known recipes
	for recipe in Globals.discovered_sauces:
		var control: Control = Control.new()
		var recipe_card: RecipeCard = RECIPE_CARD.instantiate() as RecipeCard
		recipe_card.scale *= 0.7
		grid.add_child(control)
		control.add_child(recipe_card)
		recipe_card.set_sauce(recipe)

func activate(properties: ReadableTemplate) -> void:
	overlay.texture = properties.texture
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(background, "color:a", 0.6, 0.25).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(overlay, "position:y", 360, 0.25)

func deactivate() -> void:
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(background, "color:a", 0, 0.1).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(overlay, "position:y", 1440, 0.25)
	await tween.finished
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action("exit") or event.is_action("click"):
		deactivate()
