extends Label

var parent: RigidBody2D

func _ready() -> void:
	parent = get_parent() as RigidBody2D
	visible = false

func _process(_delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	visible = true

func _on_area_2d_mouse_exited() -> void:
	visible = false
