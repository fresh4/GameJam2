extends Node2D
class_name DraggableObject

@onready var area: Area2D = %DetectionArea

var parent: RigidBody2D
var hovered: bool = false
var dragging: bool = false

func _ready() -> void:
	parent = get_parent() as RigidBody2D

func _process(_delta: float) -> void:
	if dragging:
		parent.apply_central_force((parent.get_viewport().get_mouse_position() - parent.get_position()) * 50 - parent.linear_velocity*6)
		# I don't actually know a damn thing about how the above works

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and hovered:
		dragging = true
	elif Input.is_action_just_released("click"): 
		dragging = false

func _on_area_2d_mouse_entered() -> void:
	hovered = true

func _on_area_2d_mouse_exited() -> void:
	hovered = false
