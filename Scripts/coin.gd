extends RigidBody2D
class_name Coin

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and abs(body.linear_velocity.y) > 1: return
	if not abs(linear_velocity.y) > 3: return
	AudioManager.play_random(AudioManager.COIN_CLACKS)
	if not body is Coin and not body is Pepper:
		AudioManager.play_audio(AudioManager.COIN_ON_CERAMIC)
