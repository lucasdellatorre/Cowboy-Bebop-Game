extends Area2D

var dead = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead == false:
		$AnimatedSprite.play("idle")


func _on_Ninja_area_entered(area):
	if area.is_in_group("stick"):
		dead = true
		$AnimatedSprite.play("hitstun")
		
		



func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroyed":
		queue_free()
	elif $AnimatedSprite.animation == "hitstun":
		$AnimatedSprite.play("idle")
