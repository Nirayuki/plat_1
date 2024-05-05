extends Area2D

@onready var audio = %pickup_audio
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	if body.name == "Personagem":
		animation_player.play("pick_up")
		body.get_pickup()
