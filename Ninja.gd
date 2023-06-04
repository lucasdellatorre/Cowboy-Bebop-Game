extends Area2D

enum StateMachine { IDLE, WALK, ATTACK, DEATH }

const speed := 80
const DIST_FOLLOW := 300
const DIST_ATTACK := 50
var distance := 10
var direction := 0

var dead = false
var life = 100
var is_hitten = false
var animation = ""
var state = StateMachine.IDLE

onready var animation_player = $AnimatedSprite
onready var body = $Body
onready var player = owner.get_child(0).get_node("Player") # precisa do get_child(0) por causa do level
onready var ninja = owner.get_child(0).get_node("Ninja")

func _process(delta):
	distance = global_position.distance_to(player.global_position)
	match state:
		StateMachine.IDLE:
			_set_animation("idle")
			if distance <= DIST_FOLLOW:
				_enter_state(StateMachine.WALK)
		StateMachine.WALK:
			_set_animation("walk")
			_flip()
		StateMachine.ATTACK:
			_set_animation("attack")
		StateMachine.DEATH:
			_set_animation("destroyed")
	
#	if is_hitten:
#		$AnimatedSprite.play("hitstun")
#	elif !dead:
#		$AnimatedSprite.play("idle")		
#	elif dead:
#		$AnimatedSprite.play("destroyed")	

func _flip() -> void:
	print("player pos: ", player.global_position.x)
	print("ninja pos: ",  global_position.x)
	if ninja.global_position.x < player.global_position.x:
		ninja.set_scale(Vector2(-1, 1))
		direction = -1
	elif ninja.global_position.x > player.global_position.x:
		print("chegou ali")
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
		is_hitten = true
		print("acertou o alvo")
		$AnimatedSprite.play("hitstun")
		life -= 20
		print("life ", life)
		if life <= 0:
			is_hitten = false
			dead = true
			
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroyed":
		queue_free()
	elif $AnimatedSprite.animation == "hitstun":
		is_hitten = false
		$AnimatedSprite.play("idle")
