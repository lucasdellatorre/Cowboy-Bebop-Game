extends KinematicBody2D

export (int) var speed = 180

onready var sprite = $AnimatedSprite

var velocity = Vector2()

func get_8way_input():
	velocity.x = Input.get_action_strength("movement_right")-Input.get_action_strength("movement_left")	
	velocity.y = Input.get_action_strength("movement_down")-Input.get_action_strength("movement_up")
	velocity = velocity.normalized() * speed
	if velocity.x > 0:
		sprite.set_flip_h(false)
		sprite.play("walk")
	elif velocity.x < 0:
		sprite.set_flip_h(true)
		sprite.play("walk")
	# PRECISAMOS DE SPRITE DE INDO PRA BAIXO
	#elif velocity.y > 0:
	#	sprite.play("down")
	elif velocity.y < 0:
		sprite.play("walkup")
	else:
		sprite.play("idle")

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("movement_right"):
		velocity.x += 1
	if Input.is_action_pressed("movement_left"):
		velocity.x -= 1
	if Input.is_action_pressed("movement_down"):
		velocity.y += 1
	if Input.is_action_pressed("movement_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_8way_input()
	velocity = move_and_slide(velocity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
