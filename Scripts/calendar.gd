extends Sprite2D
class_name Calendar

@onready var area: Area2D = $Area2D
@onready var circle: Sprite2D = $Circle
@onready var harvests_timings: Sprite2D = $HarvestsTimings

var hovering: bool = false
var disabled: bool = false
var clock_points: Array[Node2D]

func _ready() -> void:
	for child in harvests_timings.get_children():
		clock_points.append(child)
	circle.position = clock_points[1].position

func set_hover(value: bool) -> void:
	hovering = value
	Globals.game_manager.tooltips.toggle_hint(0, value, "Progress Time")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hovering and not disabled:
		Globals.game_manager._on_button_pressed()
		var point = Globals.game_manager.current_round + 1
		var tween = get_tree().create_tween()
		if point >= Globals.game_manager.MAX_ROUNDS: point = 0
		tween.tween_property(circle, "position", clock_points[point].position, Globals.game_manager.progress_delay)
		disabled = true
		Input.set_custom_mouse_cursor(Globals.DEFAULT)
		await get_tree().create_timer(Globals.game_manager.progress_delay).timeout
		if hovering:
			Input.set_custom_mouse_cursor(Globals.POINTER)
		disabled = false

func _on_area_2d_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(Globals.POINTER)
	set_hover(true)

func _on_area_2d_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(Globals.DEFAULT)
	set_hover(false)
