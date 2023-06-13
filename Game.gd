extends Node2D

var player : KinematicBody2D

var currentScene = null
var endLine : Position2D

func _ready() -> void:
	currentScene = get_child(0) # pega o Level1, etc
	endLine = currentScene.get_node("Scenario/EndLine")
	player = currentScene.get_node("Player")
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("death"):
		call_deferred("goto_scene", "res://GameOver.tscn")
		
	if endLine == null:
		return
		
	if player.position.x > endLine.position.x:
		get_tree().change_scene("res://EndGame.tscn")

func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(0)
	world.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instance()
	get_tree().get_root().add_child(currentScene)
	#self.add_child(currentScene)
	
