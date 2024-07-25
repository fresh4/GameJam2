extends Area2D
class_name DraggableObject

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
		set_cursor()
	elif Input.is_action_just_released("click"):
		dragging = false
		set_cursor()
	if Input.is_action_pressed("scroll_up") and dragging:
		rotate_object(3500)
	elif Input.is_action_pressed("scroll_down") and dragging:
		rotate_object(-3500)

func rotate_object(force: float) -> void:
	parent.apply_torque(force * parent.mass)

# TODO: Insufficient. Need a single source of truth instead of doing this in this
# script which has many instanced objects running the same code
func set_cursor() -> void:
	if dragging:
		Input.set_custom_mouse_cursor(Globals.HAND_CLOSED, Input.CURSOR_ARROW, Vector2(32,32))
	elif hovered and not dragging:
		Input.set_custom_mouse_cursor(Globals.HAND_OPEN, Input.CURSOR_ARROW, Vector2(32,32))
	elif not hovered and not dragging:
		Input.set_custom_mouse_cursor(Globals.DEFAULT, Input.CURSOR_ARROW, Vector2(4,4))
	
func _on_mouse_entered() -> void:
	hovered = true
	set_cursor()

func _on_mouse_exited() -> void:
	hovered = false
	set_cursor()
