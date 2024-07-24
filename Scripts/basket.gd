extends StaticBody2D
class_name Basket

@export var pepper_sold: PepperTemplate

@onready var basket_area: Area2D = %BasketArea
@onready var collider: CollisionPolygon2D = $Collider

var coins: int = 0
