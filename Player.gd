extends KinematicBody2D

export (int) var speed = 140
export (float) var speed_y = .5
export (int) var health = 100

onready var sprite = $AnimatedSprite

var velocity = Vector2()
var block_movement = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack_normal":
		$AttackArea/CollisionShape2D.disabled = true
		block_movement = false


func handle_melee():
	sprite.play("attack_normal")
	block_movement = true
	$AttackArea/CollisionShape2D.disabled = false

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


func _on_pizza_area_entered(area: Area2D) -> void:
	#print_debug(health)
	#if area.get_instance_id() == $Player.get_instance_id():
	health = health + 10
