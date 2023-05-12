extends KinematicBody2D

export (int) var speed = 140
export (float) var speed_y = .5

onready var sprite = $AnimatedSprite

var velocity = Vector2()
var block_movement = false

func handle_melee():
#	if hitbox.has_someone():
	sprite.play("attack_normal")
	block_movement = true
	yield( sprite, "animation_finished" )
	block_movement = false
#		sound.play("hit")
#		enemy

func get_8way_input():
	if block_movement:
		velocity.x = 0
		velocity.y = 0
		return
	velocity.x = Input.get_action_strength("movement_right")-Input.get_action_strength("movement_left")	
	velocity.y = Input.get_action_strength("movement_down")-Input.get_action_strength("movement_up") 
	velocity = velocity.normalized() * speed
	velocity.y = velocity.y * speed_y
	if Input.is_action_pressed("melee"):
		handle_melee()
	elif velocity.x > 0:
		sprite.set_flip_h(false)
		sprite.play("walk")
	elif velocity.x < 0:
		sprite.set_flip_h(true)
		sprite.play("walk")
	elif velocity.y > 0:
		sprite.play("walk")
	elif velocity.y < 0:
		sprite.play("walkup")
	else:
		sprite.play("idle")

func _physics_process(delta):
	get_8way_input()
	velocity = move_and_slide(velocity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
