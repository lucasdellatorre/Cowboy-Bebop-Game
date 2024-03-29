extends KinematicBody2D

export (int) var speed = 140
export (int) var health = 100
export (float) var speed_y = .5
export (float) var dash_speed = 300
export (float) var dash_length = 30

var velocity = Vector2()
var block_movement = false
var knockback = 0

onready var dash = $Dash
onready var sprite = $AnimatedSprite
onready var hud = owner.get_node("HUD")

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "attack_normal":
		$AttackArea/CollisionShape2D.disabled = true
		block_movement = false
	elif sprite.animation == "attack_bite":
		$AttackArea/attack_bite.disabled = true
		block_movement = false
	elif sprite.animation == "hitstun":
		$HurtBox/CollisionShape2D.disabled = false
		block_movement = false
	#gambi, por algum motivo a mordida tava fincado ativa
	$AttackArea/attack_bite.disabled = true


func handle_melee(attack):
	sprite.play(attack)
	block_movement = true
	if attack == "attack_bite":
		$AttackArea/attack_bite.disabled = false
	else:
		$AttackArea/CollisionShape2D.disabled = false
		
func handle_stun():
	sprite.play("hitstun")
	block_movement = true
	$HurtBox/CollisionShape2D.disabled = true
	if sprite.is_flipped_h():
			knockback = 300
	else:
			knockback = -300

func get_8way_input():
	if block_movement:
		velocity.x = 0
		velocity.y = 0
		return
	if Input.is_action_pressed("dash") && dash.can_dash && !dash.is_dashing():
		dash.start_dash(sprite, dash_length)
	elif Input.is_action_pressed("melee"):
		handle_melee("attack_normal")
	elif Input.is_action_pressed("attack_bite"):
		handle_melee("attack_bite")
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
	elif Input.is_action_pressed("victory"): # victory
		sprite.play("victory")
	elif Input.is_action_pressed("movement_down"):
		sprite.play("walk")
	else:
		sprite.play("idle")
		
	velocity.x = Input.get_action_strength("movement_right")-Input.get_action_strength("movement_left")
	velocity.y = Input.get_action_strength("movement_down")-Input.get_action_strength("movement_up") 
	
	var move_speed = dash_speed if dash.is_dashing() else speed
	
	velocity = velocity.normalized() * move_speed
	velocity.y = velocity.y * speed_y
		
func _physics_process(delta):
	if sprite.animation == "hitstun":
		if sprite.is_flipped_h():
			knockback = knockback - 5
		else:
			knockback = knockback + 5
		move_and_slide(Vector2(knockback,0))
	hud.update_player_hud(health)
	get_8way_input()
	velocity = move_and_slide(velocity)
	
	
func _on_pizza_body_entered(body: Node) -> void:
	print("entrou na pizza")
	if (health >= 90):
		health = 100
	else:
		health = health + 50

func _on_HurtBox_area_entered(area: Area2D) -> void:
	if dash.is_dashing(): return
	
	if area.is_in_group("boss_hand"):
		health -= 30
		handle_stun()
	elif area.is_in_group("hand"):
		health -= 15
		handle_stun()
	if health <= 0:
		get_tree().change_scene("res://GameOver.tscn")
	
	# var base_damage = hitbox.damage
	#self.health -+ base_damage
