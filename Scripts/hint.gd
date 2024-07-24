extends CanvasLayer
class_name Hint

@onready var left_click: Sprite2D = $left_click
@onready var right_click: Sprite2D = $right_click
@onready var left_label: Label = $left_click/Label
@onready var right_label: Label = $right_click/Label

var clicks: Array[Sprite2D]

func _ready() -> void:
	clicks = [left_click, right_click]

func toggle_hint(side: int) -> void:
		clicks[side].visible = not clicks[side].visible
