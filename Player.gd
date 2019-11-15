extends RigidBody2D

var velocity = Vector2(0, 0)
const ACCELERATION = 300
var cannon_angle = 0
var charge_start_time = 0

func _ready():
	pass	
	get_node("..//MidiController").connect("note_on", self, "note_on")
	get_node("..//MidiController").connect("note_off", self, "note_off")

func note_on(pitch, velocity):
	print(pitch)
	cannon_angle = (pitch - 48) * 10
	charge_start_time = OS.get_ticks_msec()
	
func note_off(pitch, velocity):
	var direction = Vector2(0, -100).rotated($Cannon.rotation)
	print(pitch)
	var projectile = preload("res://Projectile.tscn").instance()
	projectile.rotation_degrees = $Cannon.rotation_degrees
	projectile.position = direction + position
	get_parent().add_child(projectile)
	print($Cannon.rotation_degrees)
	projectile.apply_central_impulse(direction * 2 * max((OS.get_ticks_msec() - charge_start_time) / 200, 1))

func _process(delta):
	$Cannon.rotation_degrees = lerp($Cannon.rotation_degrees, cannon_angle, delta * 5)
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




func _on_MidiController_note_on(pitch, velocity):
	print(pitch)
	pass # Replace with function body.
