extends Node2D

var player : KinematicBody2D

var currentScene = null
var endLine : Position2D

var boss_killed = false

func _on_Boss_boss_killed():
	boss_killed = true

func _ready() -> void:
	currentScene = get_child(0) # pega o Level1, etc
	currentScene.get_node("Boss").connect("boss_killed", self, "_on_Boss_boss_killed")
	endLine = currentScene.get_node("Scenario/EndLine")
	player = currentScene.get_node("Player")
	
func _physics_process(delta: float) -> void:
	if endLine == null:
		return
		
	if player.position.x > endLine.position.x && boss_killed:
		get_tree().change_scene("res://EndGame.tscn")

func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(0)
	get_tree().change_scene(path)
