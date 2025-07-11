extends Area2D


var tween

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 60), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		$AudioStreamPlayer2D.play()
		tween.tween_callback(queue_free)
