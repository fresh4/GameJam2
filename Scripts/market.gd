extends Node2D
class_name Shop

@onready var baskets_node: Node2D = %Baskets
@onready var button: Button = %Button

var summoned: bool = false
var baskets: Array[Basket]
var starting_pos: Vector2 = Vector2(673, 800)
var selling_pos: Vector2 = Vector2(673, 433)

func _ready() -> void:
	position = starting_pos
	for basket in baskets_node.get_children():
		if basket is Basket: baskets.append(basket)

func summon() -> void:
	Globals.game_manager.shop_opened = true
	summoned = true
	var tween = get_tree().create_tween()
	
	toggle_basket_collider(false)
	tween.tween_property(self, "position", selling_pos, 0.25)
	await tween.finished
	toggle_basket_collider(true)
	
func unsummon() -> void:
	Globals.game_manager.shop_opened = false
	summoned = false
	var tween = get_tree().create_tween()
	
	toggle_basket_collider(false)
	tween.tween_property(self, "position", starting_pos, 0.25)
	await tween.finished
	toggle_basket_collider(true)

@warning_ignore("integer_division")
func purchase() -> void:
	for basket in baskets:
		if basket.is_sell_basket:
			sell(basket)
			continue
		var coins = len(basket.basket_area.get_overlapping_bodies())
		if not coins: continue
		if coins >= basket.pepper_sold.cost:
			var num_of_peppers_to_sell = int(coins/basket.pepper_sold.cost)
			var total_cost = num_of_peppers_to_sell * basket.pepper_sold.cost
			for idx in num_of_peppers_to_sell:
				var pepper: Pepper = load(basket.pepper_sold.path_to_prefab).instantiate()
				pepper.position = Globals.pepper_spawn_point
				Globals.inside.add_child(pepper)
				AudioManager.play_random(AudioManager.POPS)
			for idx in total_cost:
				basket.basket_area.get_overlapping_bodies()[idx].queue_free()

func sell(basket: Basket) -> void:
	for body in basket.basket_area.get_overlapping_bodies():
		if body is Sauce:
			Globals.game_manager.pay(body.properties.value)
			body.queue_free()

func toggle_basket_collider(value: bool) -> void:
	for basket in baskets:
		basket.collider.disabled = not value

func _on_button_pressed() -> void:
	purchase()
	unsummon()
