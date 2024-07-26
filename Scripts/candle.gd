extends StaticBody2D
class_name Candle

@export var noise: NoiseTexture2D

@onready var flame_sprite: AnimatedSprite2D = $FlameSprite
@onready var flame_area: Area2D = $FlameArea
@onready var candle_light: PointLight2D = $Light

var time: float = 0.0
var lit: bool = false

func _ready() -> void:
	light(false)

func _process(delta: float) -> void:
	if not lit: return
	time += delta
	var value = abs(noise.noise.get_noise_1d(time))
	candle_light.energy = clamp(value, 0.24, 0.8)
	candle_light.texture_scale = clamp(value*2, 1.1, 1.2)

func light(value: bool = true) -> void:
	lit = value
	flame_sprite.visible = value
	flame_area.monitoring = value
	flame_area.monitorable = value
	candle_light.visible = value

func _on_flame_area_body_entered(body: Node2D) -> void:
	for i in body.get_children(): if i is CPUParticles2D: return
	var flame_prefab = Globals.FLAME_PARTICLES.instantiate()
	body.add_child(flame_prefab)
	await get_tree().create_timer(5).timeout
	if is_instance_valid(flame_prefab): body.queue_free()
