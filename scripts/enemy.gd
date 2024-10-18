extends Area2D
class_name Enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().reload_current_scene()
	elif body is Bullet:
		queue_free()
		body.queue_free()
