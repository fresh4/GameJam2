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
		var letter: Letter = load(Globals.readables[readable_type]).instantiate()
		Globals.game_manager.add_child(letter)
		letter.activate(properties)
		is_read = true
		unread_sprite.stop()
		unread_sprite.visible = false

func _on_mouse_entered() -> void:
	Globals.game_manager.tooltips.toggle_hint(1, true)
	hovering = true

func _on_mouse_exited() -> void:
	Globals.game_manager.tooltips.toggle_hint(1, false)
	hovering = false
