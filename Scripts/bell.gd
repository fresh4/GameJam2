extends Node2D

@onready var bell_top: Sprite2D = $BellTop
@onready var bell_middle: Sprite2D = $BellMiddle
@onready var bell_bottom: Sprite2D = $BellBottom
@onready var bell_area: Area2D = $BellArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var hovering: bool = false

func ring() -> void:
	if not Globals.game_manager.market.summoned:
		Globals.game_manager.market.summon()
	else: 
		Globals.game_manager.market.unsummon()
	animation_player.play("ring")
	AudioManager.play_audio(AudioManager.BELL_1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hovering:
		ring()

func _on_bell_area_mouse_entered() -> void:
	hovering = true

func _on_bell_area_mouse_exited() -> void:
	hovering = false
