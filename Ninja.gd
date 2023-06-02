extends Area2D

var dead = false
var life = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		$AnimatedSprite.play("destroyed")
	else:
		$AnimatedSprite.play("idle")		
		
		


func _on_Ninja_area_entered(area):
	if area.is_in_group("stick"):
		$AnimatedSprite.play("hitstun")
		life = life - 20
		if life <= 0:
			dead = true
			
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroyed":
		queue_free()
	elif $AnimatedSprite.animation == "hitstun":
		$AnimatedSprite.play("idle")
