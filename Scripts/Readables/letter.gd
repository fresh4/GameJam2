extends Readable
class_name Letter

@onready var background: ColorRect = %Background
@onready var overlay: Sprite2D = %Overlay
@onready var recipe_card: RecipeCard = %RecipeCard
@onready var content: Label = %Content

func _ready() -> void:
	content.text = ""
	background.color.a = 0
	overlay.position.y = 1440

func activate(properties: ReadableTemplate) -> void:
	if properties.content: content.text = properties.content
	recipe_card.visible = properties.has_recipe
	overlay.texture = properties.texture
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(background, "color:a", 0.6, 0.25).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(overlay, "position:y", 360, 0.25)

func deactivate() -> void:
	AudioManager.play_audio(AudioManager.PAPER_CLOSE_1)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(background, "color:a", 0, 0.1).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(overlay, "position:y", 1440, 0.25)
	await tween.finished
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit") or event.is_action_pressed("click"):
		deactivate()
