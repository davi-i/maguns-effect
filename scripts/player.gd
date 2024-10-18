extends CharacterBody2D
class_name Player


const SPEED = 600.0
const JUMP_VELOCITY = -900.0

@onready var guns: Array[Gun] = [$ChangesDirection/Shotgun, $ChangesDirection/Rifle, $ChangesDirection/ Pistol]

var active_gun = 0 :
	set(new_value):
		guns[active_gun].visible = false
		active_gun = new_value % len(guns)
		guns[active_gun].visible = true
		Global.gun_changed.emit(guns[active_gun])

var shooting = false

func _process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		$ChangesDirection.scale.x = sign(direction)
	
	if shooting:
		guns[active_gun].shoot()
		if not guns[active_gun].full_auto:
			shooting = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shooting = true
	elif event.is_action_released("shoot"):
		shooting = false
	elif event.is_action("kill"):
		guns[active_gun].kill_bullets()
	elif event.is_action_pressed("hopup_up"):
		guns[active_gun].backspin_drag += .01
		Global.gun_changed.emit(guns[active_gun])
	elif event.is_action_pressed("hopup_down"):
		guns[active_gun].backspin_drag -= .01
		Global.gun_changed.emit(guns[active_gun])
	elif Input.is_action_pressed("prev_gun"):
		active_gun -= 1
	elif Input.is_action_pressed("next_gun"):
		active_gun += 1
	elif Input.is_action_pressed("toggle_full_auto"):
		guns[active_gun].full_auto = !guns[active_gun].full_auto
		Global.gun_changed.emit(guns[active_gun])
