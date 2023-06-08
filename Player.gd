extends KinematicBody2D

export (int) var speed = 140
export (float) var speed_y = .5
export (int) var health = 75

onready var sprite = $AnimatedSprite
onready var hud = owner.get_node("HUD")

var velocity = Vector2()
var block_movement = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack_normal":
		$AttackArea/CollisionShape2D.disabled = true
		block_movement = false


func handle_melee():
	hud.update_player_hud(health)
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
	elif Input.is_action_pressed("movement_right"):
		sprite.set_flip_h(false)
		get_node("AttackArea").set_scale(Vector2(1, 1))
		sprite.play("walk")
	elif Input.is_action_pressed("movement_left"):
		sprite.set_flip_h(true)
		get_node("AttackArea").set_scale(Vector2(-1, 1))
		sprite.play("walk")
	elif Input.is_action_pressed("movement_up"):
		sprite.play("walk")
	elif Input.is_action_pressed("movement_down"):
		sprite.play("walkup")
	else:
		sprite.play("idle")

func _physics_process(delta):
	get_8way_input()
	velocity = move_and_slide(velocity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_pizza_body_entered(body: Node) -> void:
	print("Entrou na pizza")
	if (health >= 90):
		health = 100
	else:
		health = health + 10
	print("life ", health)

func _take_damage():
	
	pass
	
