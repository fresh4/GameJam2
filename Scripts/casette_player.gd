extends StaticBody2D

@onready var button_area: Area2D = $ButtonArea
@onready var wheels_animation_player: AnimationPlayer = $WheelsAnimationPlayer
@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer

var hovered: bool = false
var playing: bool = false

func _ready() -> void:
	button_area.mouse_entered.connect(button_hover)
	button_area.mouse_exited.connect(button_exit)
	toggle_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hovered:
		toggle_player()

func toggle_player() -> void:
	if not playing:
		button_animation_player.play("button_click")
		wheels_animation_player.play("spin")
		playing = true
		# TODO: Play the music audio stream
	else:
		button_animation_player.play_backwards("button_click")
		await button_animation_player.animation_finished
		wheels_animation_player.pause()
		playing = false
		# TODO: Stop the music audio stream

func button_hover():
	hovered = true
	
func button_exit():
	hovered = false
