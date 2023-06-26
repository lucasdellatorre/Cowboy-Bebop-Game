extends Area2D

enum StateMachine { IDLE, WALK, ATTACK, DEATH, HITTEN }

const speed := 90
const DIST_FOLLOW := 250
const DIST_ATTACK := 60
var distance := 10
var direction := 0

var life = 50
var animation = ""
var state = StateMachine.IDLE
var velocity = Vector2.ZERO
var previous_position = Vector2.ZERO
var can_attack = true


onready var animation_player = $AnimatedSprite
onready var body = $Body
onready var player = owner.get_child(0).get_node("Player") # precisa do get_child(0) por causa do level
onready var ninja = owner.get_child(0).get_node("Ninja2")

func _ready():
	$Timer.connect("timeout", self, "_on_attack_timeout")
	
func _on_attack_timeout():
	can_attack = true

func _process(delta):
	distance = global_position.distance_to(player.global_position)
	velocity = ((position - previous_position) / delta).normalized()
	previous_position = position

	match state:
		StateMachine.IDLE:
			_set_animation("idle")
			if distance <= DIST_FOLLOW:
				_enter_state(StateMachine.WALK)
		StateMachine.WALK:
			_set_animation("walk")
			_flip()
			#ninja.velocity.x = direction * speed
			#var direction = (player.global_position - ninja.global_position).normalized()
			#ninja.global_position += direction * speed * delta
			var xMovement = Vector2(direction * speed * delta, 0)
			translate(xMovement * - 1)
			
			if distance >= DIST_FOLLOW:
				_enter_state(StateMachine.IDLE)
				
			if distance <= DIST_ATTACK:
				_enter_state(StateMachine.ATTACK)
		StateMachine.ATTACK:
			if can_attack:
				_set_animation("attack")
				$AttackArea/CollisionShape2D.disabled = false
				$Timer.start()
			can_attack = false
			
		StateMachine.HITTEN:
			_set_animation("hitstun")
		StateMachine.DEATH:
			_set_animation("destroyed")
			
func _flip() -> void:
	if ninja.global_position.x < player.global_position.x:
		ninja.set_scale(Vector2(-1, 1))
		direction = -1
	elif ninja.global_position.x > player.global_position.x:
		ninja.set_scale(Vector2(1, 1))
		direction = 1

func _enter_state(new_state) -> void:
	if state != new_state:
		state = new_state

func _set_animation(anim) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)
		
func _on_Ninja_area_entered(area):
	if area.is_in_group("stick"):
		_enter_state(StateMachine.HITTEN)
		life -= 20
		if life <= 0:
			_enter_state(StateMachine.DEATH)
			
func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"destroyed":
			call_deferred("free")
		"hitstun":
			_enter_state(StateMachine.IDLE)
		"attack":
			$AttackArea/CollisionShape2D.disabled = true
			_enter_state(StateMachine.IDLE)
		"walk":
			_enter_state(StateMachine.IDLE)
