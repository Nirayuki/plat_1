extends Node2D

@export var speed = 40
@export var direction = 1
@export var flipping = false

@onready var anim = %Animate
@onready var rayright = %RayCastRight
@onready var rayleft = %RayCastLeft
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * speed * delta
	
	if rayright.is_colliding():
		direction = -1
	elif rayleft.is_colliding():
		direction = 1
	
	if direction < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false


func _on_area_2d_body_entered(body):
	if body.name == "Personagem":
		body._kill()
