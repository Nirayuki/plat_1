extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var coins = 0
var is_dying = false

@onready var animation = %Animation
@onready var deathanimation = %DeathAnimation
@onready var jump_audio = $Jump_Audio
@export var label_coin : Label

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	coins = get_tree().get_nodes_in_group("coins").size()
	label_coin.text = str(coins)

func _physics_process(delta):
	if is_dying:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_audio.play()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		if velocity.x < 0:
			animation.flip_h = true
		else: 
			animation.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	_state_machine(direction)
	move_and_slide()
	
	
func _state_machine(direction):
	if is_dying:
		return
	
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if animation.name != state:
		animation.play(state)


func get_pickup():
	coins = coins - 1
	label_coin.text = str(coins)
	


func _on_diezone_body_entered(body):
	queue_free()
	print("Você morreu")
	
	
func _kill():
	if is_dying:
		return
	
	is_dying = true
	animation.play("death")
	$"../CanvasLayer/ColorRect".visible = true
	$"../CanvasLayer/Label".visible = true
	$"../CanvasLayer/playagain".visible = true
	
