extends CanvasLayer

onready var player_health = get_node("PlayerHUD/Lifebar")
onready var tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.connect("tween_completed", self, "_on_tween_completed")
	
func update_player_hud(value):
	tween.interpolate_property(player_health, "value", player_health.value, value, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_tween_completed(object: Object, key: NodePath):
	if object == player_health and key == "value":
		# Interpolation completed
		pass
