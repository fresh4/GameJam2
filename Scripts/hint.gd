extends CanvasLayer
class_name Hint

@onready var left_click: Sprite2D = $left_click
@onready var right_click: Sprite2D = $right_click
@onready var left_label: Label = $left_click/Label
@onready var right_label: Label = $right_click/Label

var clicks: Array[Sprite2D]
var labels: Array[Label]

func _ready() -> void:
	clicks = [left_click, right_click]
	labels = [left_label, right_label]

func toggle_hint(side: int, hint_visible: bool, text: String = "") -> void:
	clicks[side].visible = hint_visible
	if text != "": labels[side].text = text
