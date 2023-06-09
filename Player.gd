extends KinematicBody2D

export (int) var speed = 140
export (float) var speed_y = .5
export (int) var health = 100

onready var sprite = $AnimatedSprite
onready var hud = owner.get_node("HUD")

var velocity = Vector2()
var block_movement = false

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "attack_normal":
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
		sprite.play("walk")
	else:
		sprite.play("idle")
		
func _physics_process(delta):
	hud.update_player_hud(health)
	get_8way_input()
	velocity = move_and_slide(velocity)

func _on_pizza_body_entered(body: Node) -> void:
	if (health >= 90):
		health = 100
	else:
		health = health + 30

func _on_HurtBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("hand"):
		health -= 20
		if health <= 0:
			print("dead")
	# var base_damage = hitbox.damage
	#self.health -+ base_damage
