extends KinematicBody2D

# Declare member variables here. Examples:
var velocity = Vector2(0, 0)
const ACCELERATION = 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#velocity = Vector2(0,0)
	velocity *= 0.99
	if Input.is_action_pressed("ui_right"):
		velocity.x += ACCELERATION
	if Input.is_action_pressed("ui_down"):
		velocity.y += ACCELERATION
	if Input.is_action_pressed("ui_left"):
		velocity.x += -ACCELERATION
	if Input.is_action_pressed("ui_up"):
		velocity.y += -ACCELERATION
	move_and_collide (velocity)
	pass
