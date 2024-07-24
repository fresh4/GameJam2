extends Node2D

@onready var bell_top: Sprite2D = $BellTop
@onready var bell_middle: Sprite2D = $BellMiddle
@onready var bell_bottom: Sprite2D = $BellBottom
@onready var bell_area: Area2D = $BellArea

var hovering: bool = false

func ring() -> void:
	Globals.game_manager.market.summon()

func _input(event: InputEvent) -> void:
	if event.is_action("click") and hovering:
		ring()

func _on_bell_area_mouse_entered() -> void:
	hovering = true

func _on_bell_area_mouse_exited() -> void:
	hovering = false
