extends Area2D
class_name DraggableObject

const DRAGGER = preload("res://Assets/Art/Cursors/dragger.png")
const POINTER = preload("res://Assets/Art/Cursors/pointer.png")
const GRABBER = preload("res://Assets/Art/Cursors/grabber.png")

var parent: RigidBody2D
var hovered: bool = false
var dragging: bool = false

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	parent = get_parent() as RigidBody2D
	parent.can_sleep = false
	parent.continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
	parent.contact_monitor = true

func _physics_process(_delta: float) -> void:
	if dragging:
		# I don't actually know a damn thing about how this works
		var force = (parent.get_viewport().get_mouse_position() - parent.get_position()) * 100 - parent.linear_velocity*12
		parent.apply_central_force(force)
		
		var limit = 2500
		parent.linear_velocity.x = clampf(parent.linear_velocity.x, -limit, limit)
		parent.linear_velocity.y = clampf(parent.linear_velocity.y, -limit, limit)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and hovered:
		dragging = true
	elif Input.is_action_just_released("click"):
		dragging = false
	if Input.is_action_pressed("scroll_up") and dragging:
		rotate_object(3500)
	elif Input.is_action_pressed("scroll_down") and dragging:
		rotate_object(-3500)

func rotate_object(force: float) -> void:
	parent.apply_torque(force * parent.mass)

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false
