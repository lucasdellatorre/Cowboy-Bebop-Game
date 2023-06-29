extends Control

func _ready() -> void:
	$VBoxContainer/RetryButton.grab_focus()

func _on_RetryButton_pressed() -> void:
	get_tree().change_scene("res://Game.tscn")


func _on_MenuButton_pressed() -> void:
	get_tree().change_scene("res://Menu.tscn")
