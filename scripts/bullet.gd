extends RigidBody2D
class_name Bullet

var massa = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mass = massa / 1000

var backspin_drag

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(linear_velocity)
	var force = linear_velocity.normalized().rotated(-PI / 2) * sqrt(abs(linear_velocity.x)) * backspin_drag * sign(linear_velocity.x)
	
	apply_force(force * delta)


func _on_kill_timer_timeout() -> void:
	queue_free()
