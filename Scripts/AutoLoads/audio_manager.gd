extends Node

#region Audio Imports
const OST = preload("res://Assets/Music/Pepper_Meister_OST.ogg")

const BUBBLING_CAULDRON = preload("res://Assets/SFX/Cauldron/bubbling_cauldron.ogg")
const SAUCE_BREW_1 = preload("res://Assets/SFX/Cauldron/sauce_brew_1.ogg")
const SAUCE_BREW_2 = preload("res://Assets/SFX/Cauldron/sauce_brew_2.ogg")

const SPLOOSH_1 = preload("res://Assets/SFX/Cauldron/sploosh_1.ogg")
const SPLOOSH_2 = preload("res://Assets/SFX/Cauldron/sploosh_2.ogg")
const SPLOOSH_3 = preload("res://Assets/SFX/Cauldron/sploosh_3.ogg")

const BUTTON_A = preload("res://Assets/SFX/Pops/button_A.ogg")
const BUTTON_B = preload("res://Assets/SFX/Pops/button_B.ogg")
const BUTTON_C = preload("res://Assets/SFX/Pops/button_C.ogg")
const BUTTON_CLICK_A = preload("res://Assets/SFX/Pops/button_click_A.ogg")
const BUTTON_CLICK_B = preload("res://Assets/SFX/Pops/button_click_B.ogg")

const CASSETTE_PRESS = preload("res://Assets/SFX/Cassette/cassette_press.ogg")
const CASSETTE_PRESS_2 = preload("res://Assets/SFX/Cassette/cassette_press_2.ogg")
const CASSETTE_PRESS_3 = preload("res://Assets/SFX/Cassette/cassette_press_3.ogg")

const PAPER_CLOSE_1 = preload("res://Assets/SFX/Paper/paper_close_1.ogg")
const PAPER_OPEN_1 = preload("res://Assets/SFX/Paper/paper_open_1.ogg")

const BELL_1 = preload("res://Assets/SFX/bell_1.ogg")
const IGNITE = preload("res://Assets/SFX/ignite.ogg")
const SIZZLE = preload("res://Assets/SFX/sizzle.ogg")
const TIME = preload("res://Assets/SFX/time.ogg")
const MAIL_CHIME = preload("res://Assets/SFX/mail_chime.ogg")

const GLASS_CLACK = preload("res://Assets/SFX/glass_clack.ogg")
const GLASS_CLACK_2 = preload("res://Assets/SFX/glass_clack_2.ogg")
const GLASS_CLACK_3 = preload("res://Assets/SFX/glass_clack_3.ogg")
const GLASS_CLACK_4 = preload("res://Assets/SFX/glass_clack_4.ogg")
const GLASS_CLACK_5 = preload("res://Assets/SFX/glass_clack_5.ogg")

const COIN_CLACKS: Array[AudioStream] = [
	GLASS_CLACK,
	GLASS_CLACK_2,
	GLASS_CLACK_3,
	GLASS_CLACK_4,
	GLASS_CLACK_5
]

const CASSETTE_CLICKS: Array[AudioStream] = [
	CASSETTE_PRESS,
	CASSETTE_PRESS_2,
	CASSETTE_PRESS_3
]
const POPS: Array[AudioStream] = [
	BUTTON_A,
	BUTTON_B,
	BUTTON_C
]
const CLICKS: Array[AudioStream] = [
	BUTTON_CLICK_A,
	BUTTON_CLICK_B
]
const SFX_BREWS: Array[AudioStream] = [
	SAUCE_BREW_1,
	SAUCE_BREW_2
]
const SFX_SPLASHES: Array[AudioStream] = [
	SPLOOSH_1,
	SPLOOSH_2,
	SPLOOSH_3
]
#endregion
var menu_music_player: AudioStreamPlayer
var game_music_player: AudioStreamPlayer
var victory_music_player: AudioStreamPlayer

var current_player: AudioStreamPlayer = null
var tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func initialize_player(stream: Resource) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "Music"
	player.stream = stream
	player.volume_db = -72
	player.autoplay = true
	#player.stream_paused = true
	add_child(player)
	return player

func crossfade(new_player: AudioStreamPlayer, fade_in_t: float = 1, fade_out_t: float = 1) -> void:
	# Accept a new music player to start playing
	# Fade out the current player
	# Fade in the new player
	if new_player == current_player: return
	tween = get_tree().create_tween().set_parallel()
	#new_player.stream_paused = false
	tween.tween_property(current_player, "volume_db", -72, fade_out_t)
	tween.tween_property(new_player, "volume_db", 0, fade_in_t)
	await tween.finished
	current_player = new_player
	#current_player.stream_paused = true

func play(player: AudioStreamPlayer, fade_in_t: float = 1) -> void:
	# Start an existing audio player
	# Does not add to or overwrite the main 'current player'
	# Only meant to play atop existing elements.
	var play_tween = get_tree().create_tween()
	#player.stream_paused = false
	play_tween.tween_property(player, "volume_db", 0, fade_in_t)

func stop(player: AudioStreamPlayer, fade_out_t: float = 1) -> void:
	# Stop a specific existing audio player
	var stop_tween = get_tree().create_tween()
	stop_tween.tween_property(player, "volume_db", -72, fade_out_t)
	await stop_tween.finished
	#player.stream_paused = true

func set_volume(mixer: String, volume: float) -> float:
	var bus_idx = AudioServer.get_bus_index(mixer)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))
	return volume

func play_audio(file: AudioStream, mixer: String = "SFX", volume: float = 1) -> void:
	# given a preloaded soundfile, generate an audio stream player, spawn it
	# load the file, play it, and then destroy the player.
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = file
	audio_player.bus = mixer
	audio_player.volume_db = linear_to_db(volume)
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()

func play_random(list: Array[AudioStream]) -> void:
	var track = list.pick_random()
	play_audio(track)

#func on_scene_changed() -> void:
	## Automatically handle audio shifting based on the current scene
	#if tween and tween.is_running():
		#await tween.finished
	#
	#if get_tree().current_scene.name == "MainMenu":
		#await crossfade(menu_music_player, 0.25, 2)
	#else:
		#await crossfade(game_music_player, 0.25, 2)
