extends RigidBody2D

var velocity = Vector2(0, 0)
const ACCELERATION = 300
var cannon_angle = 0
var charge_start_time = 0

const MIDI_CHANNEL = 0

var cannon_energy = 0.0
var movement_energy = 0.0

func _ready():
	get_node("..//MidiController").connect("note_on", self, "note_on")
	get_node("..//MidiController").connect("note_off", self, "note_off")

func note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	if cannon_energy < 1.0:
		return
	cannon_energy -= 1.0
	
	$PolyVoice.note_on(pitch, velocity, channel)
	
	print(pitch)
	cannon_angle = (pitch - 48) * 10
	charge_start_time = OS.get_ticks_msec()

func note_off(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	$PolyVoice.note_off(pitch, velocity, channel)
	
	shoot()

func shoot():
	var direction = Vector2(0, -200).rotated($Cannon.global_rotation)
	var projectile = preload("res://Player/Projectile.tscn").instance()
	projectile.rotation_degrees = $Cannon.global_rotation_degrees
	projectile.position = direction + position
	get_parent().add_child(projectile)
	projectile.apply_central_impulse(linear_velocity + direction * 2 * max((OS.get_ticks_msec() - charge_start_time) / 200, 1))

func calculate_velocity_from_input(delta):
	velocity = Vector2(0,0)
	
	if movement_energy < delta:
		return velocity
		
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up"):
		movement_energy -= delta
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = ACCELERATION
	if Input.is_action_pressed("ui_down"):
		velocity.y = ACCELERATION
	if Input.is_action_pressed("ui_left"):
		velocity.x = -ACCELERATION
	if Input.is_action_pressed("ui_up"):
		velocity.y = -ACCELERATION
		
	return velocity

func _process(delta):
	$Cannon.rotation_degrees = lerp($Cannon.rotation_degrees, cannon_angle, delta * 5)
	
	if Input.is_action_just_pressed("ui_accept"):
		charge_start_time = OS.get_ticks_msec()
		shoot()
	
	var velocity = calculate_velocity_from_input(delta)
	
	add_central_force(velocity)
	# move_and_collide (velocity)

func _integrate_forces(state: Physics2DDirectBodyState):
	for i in range(state.get_contact_count()):
		var contact = preload("res://contact_particles.tscn").instance()
		contact.position = state.get_contact_local_position(i)
		contact.rotation = state.get_contact_local_normal(i).angle() + PI
		get_parent().add_child(contact)
