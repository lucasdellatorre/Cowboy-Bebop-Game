extends Node2D

const dash_delay = 0.4

onready var dash_timer: Timer = $DashTimer
onready var ghost_timer: Timer = $GhostTimer
var ghost_scene = preload("res://DashGhost.tscn")
var can_dash = true
var sprite

func instance_ghost():
	var ghost = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position.x = global_position.x
	ghost.global_position.y = global_position.y - 51
	ghost.frame = sprite.frame
	ghost.texture = sprite.frames.get_frame("walk", 0)
	ghost.flip_h = sprite.flip_h

func start_dash(sprite, duration):
	self.sprite = sprite
	dash_timer.wait_time = duration
	dash_timer.start()
	
	ghost_timer.start()
	
	instance_ghost()
	
func is_dashing():
	return !dash_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	can_dash = false
	yield(get_tree().create_timer(dash_delay), 'timeout')
	can_dash = true
	
func _on_DashTimer_timeout() -> void:
	end_dash()


func _on_GhostTimer_timeout() -> void:
	instance_ghost()
