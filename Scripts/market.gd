extends Node2D
class_name Shop

@onready var baskets_node: Node2D = %Baskets
@onready var button: Button = %Button

var summoned: bool = false
var baskets: Array[Basket]
var starting_pos: Vector2 = Vector2(673, 800)
var selling_pos: Vector2 = Vector2(673, 500)

func _ready() -> void:
	position = starting_pos
	for basket in baskets_node.get_children():
		if basket is Basket: baskets.append(basket)

func summon() -> void:
	summoned = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", selling_pos, 0.25)
	
func unsummon() -> void:
	summoned = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", starting_pos, 0.25)

@warning_ignore("integer_division")
func purchase() -> void:
	for basket in baskets:
		var coins = len(basket.basket_area.get_overlapping_bodies())
		if not coins: continue
		if coins >= basket.pepper_sold.cost:
			var num_of_peppers_to_sell = int(coins/basket.pepper_sold.cost)
			var total_cost = num_of_peppers_to_sell * basket.pepper_sold.cost
			var pepper: Pepper = load(basket.pepper_sold.path_to_prefab).instantiate()
			pepper.position = Globals.pepper_spawn_point
			for idx in num_of_peppers_to_sell:
				Globals.inside.add_child(pepper)
			for idx in total_cost:
				basket.basket_area.get_overlapping_bodies()[0].queue_free()

func _on_button_pressed() -> void:
	purchase()
	unsummon()
