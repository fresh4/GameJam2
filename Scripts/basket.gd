extends StaticBody2D
class_name Basket

@export var pepper_sold: PepperTemplate
@export var is_sell_basket: bool = false
@onready var basket_area: Area2D = %BasketArea
@onready var collider: CollisionPolygon2D = $Collider

var coins: int = 0
