extends KinematicBody2D

export (int) var speed = 140
export (float) var speed_y = .5
export (int) var health = 100

onready var sprite = $AnimatedSprite
onready var hud = owner.get_node("HUD")

var dash_direction: Vector2
var can_dash = true
var is_dashing = false
export (float) var dash_speed = 2
export (float) var dash_length
onready var dash_timer: Timer = get_node("DashTimer")

var velocity = Vector2()
var block_movement = false

func _ready():
	dash_timer.connect("timeout", self, "_on_dash_timeout")

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "attack_normal":
		$AttackArea/CollisionShape2D.disabled = true
		block_movement = false
	elif sprite.animation == "attack_bite":
		$AttackArea/attack_bite.disabled = true
		block_movement = false

func handle_melee(attack):
	sprite.play(attack)
	block_movement = true
	if attack == "attack_bite":
		$AttackArea/attack_bite.disabled = false
	else:
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
	elif Input.is_action_pressed("movement_down"):
		sprite.play("walk")
	else:
		sprite.play("idle")
		
func _physics_process(delta):
	hud.update_player_hud(health)
	handle_dash()
	get_8way_input()
	velocity = move_and_slide(velocity)
	
func handle_dash() -> void:
	if Input.is_action_just_pressed("dash") and can_dash:
		print("apertou a braba")
		is_dashing = true
		can_dash = false
		dash_direction = dash()
		dash_timer.start(dash_length)
	
	if is_dashing:
		dash_direction = move_and_slide(dash_direction)
		

func dash() -> Vector2:
	var input_vector = Vector2.ZERO
	velocity.x = Input.get_action_strength("movement_right")-Input.get_action_strength("movement_left")
	velocity.y = Input.get_action_strength("movement_down")-Input.get_action_strength("movement_up")
	input_vector = input_vector.clamped(1)
	if input_vector == Vector2.ZERO:
		if sprite.flip_h:
			input_vector.x = -1
		else:
			input_vector.x = 1
	return input_vector * dash_speed
	
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

func _on_dash_timeout() -> void:
	is_dashing = false
	can_dash = true
