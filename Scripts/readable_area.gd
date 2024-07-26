extends Area2D
class_name ReadableArea

@export var properties: ReadableTemplate
@export var readable_type: Globals.READABLE_TYPE

@onready var unread_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_read: bool = false
var hovering: bool = false

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _input(event: InputEvent) -> void:
	if hovering and event.is_action_pressed("right_click"):
		# THE OVERLAY OBJECT THAT YOU ACTUALLY READ
		var letter: Readable = load(Globals.readables[readable_type]).instantiate()
		Globals.game_manager.add_child(letter)
		if properties.has_recipe:
			letter.recipe_card.set_sauce(properties.sauce)
		letter.activate(properties)
		is_read = true
		hovering = false
		unread_sprite.stop()
		Globals.game_manager.tooltips.toggle_hint(1, false)
		for child in get_parent().get_children():
			if child is DraggableObject:
				child.dragging = false
		unread_sprite.visible = false

func _on_mouse_entered() -> void:
	Globals.game_manager.tooltips.toggle_hint(1, true, properties.hint)
	hovering = true

func _on_mouse_exited() -> void:
	Globals.game_manager.tooltips.toggle_hint(1, false, properties.hint)
	hovering = false
