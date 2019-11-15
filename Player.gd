extends RigidBody2D

var velocity = Vector2(0, 0)
const ACCELERATION = 300

func _ready():
	pass

func _process(delta):
	velocity = Vector2(0,0)
	#velocity *= 0.99
	if Input.is_action_pressed("ui_right"):
		velocity.x = ACCELERATION
	if Input.is_action_pressed("ui_down"):
		velocity.y = ACCELERATION
	if Input.is_action_pressed("ui_left"):
		velocity.x = -ACCELERATION
	if Input.is_action_pressed("ui_up"):
		velocity.y = -ACCELERATION
	add_central_force(velocity)
	# move_and_collide (velocity)