extends CanvasLayer
class_name Hint

@onready var left_click: Sprite2D = $left_click
@onready var right_click: Sprite2D = $right_click
@onready var left_label: Label = $left_click/Label
@onready var right_label: Label = $right_click/Label
@onready var discovery_label: Label = $DiscoveryLabel

var clicks: Array[Sprite2D]
var labels: Array[Label]

func _ready() -> void:
	clicks = [left_click, right_click]
	labels = [left_label, right_label]
	discovery_label.position.y = 720

func toggle_hint(side: int, hint_visible: bool, text: String = "") -> void:
	clicks[side].visible = hint_visible
	if text != "": labels[side].text = text

func discovered_recipe() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(discovery_label, "position:y", 0, 0.5)
	tween.tween_property(discovery_label, "modulate:a", 1, 0.5)
	await get_tree().create_timer(2).timeout
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(discovery_label, "modulate:a", 0, 0.5)
	await tween.finished
	discovery_label.position.y = 720
	
