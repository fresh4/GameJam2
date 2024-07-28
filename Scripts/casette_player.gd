extends RigidBody2D

@onready var button_area: Area2D = $ButtonArea
@onready var wheels_animation_player: AnimationPlayer = $WheelsAnimationPlayer
@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer

var hovered: bool = false
var playing: bool = false
var music_player: AudioStreamPlayer2D

func _ready() -> void:
	music_player = AudioStreamPlayer2D.new()
	add_child(music_player)
	music_player.stream = AudioManager.OST
	music_player.bus = "Music"
	music_player.play()
	button_area.mouse_entered.connect(button_hover)
	button_area.mouse_exited.connect(button_exit)
	toggle_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hovered:
		toggle_player()

func toggle_player() -> void:
	AudioManager.play_random(AudioManager.CASSETTE_CLICKS)
	if not playing:
		button_animation_player.play("button_click")
		await button_animation_player.animation_finished
		wheels_animation_player.play("spin")
		playing = true
		music_player.stream_paused = false
	else:
		button_animation_player.play_backwards("button_click")
		await button_animation_player.animation_finished
		wheels_animation_player.pause()
		playing = false
		music_player.stream_paused = true

func button_hover():
	hovered = true
	
func button_exit():
	hovered = false

func _on_button_area_body_entered(_body: Node2D) -> void:
	toggle_player()
