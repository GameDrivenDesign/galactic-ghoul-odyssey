extends RigidBody2D

var velocity = Vector2(0, 0)
const ACCELERATION = 300
var cannon_angle = 0
var charge_start_time = 0

const MIDI_CHANNEL = 1

onready var effect = get_node("effect")

var cannon_energy = 0.0
var movement_energy = 0.0
const MAX_HITPOINTS = 1000
var hitpoints = MAX_HITPOINTS

var shake_amplitude = 0

func add_shake(amp):
	shake_amplitude += amp

func _ready():
	get_node("..//MidiController").connect("note_on", self, "note_on")
	get_node("..//MidiController").connect("note_off", self, "note_off")
	define_effects(get_node("spaceperson1"))
	define_effects(get_node("spaceperson2"))
	define_effects(get_node("spaceperson3"))
	effect.start()
	$"UI/Hitpoints".max_value = MAX_HITPOINTS

func define_effects(sprite):
	var old_vec = sprite.get_position()
	var new_vec = old_vec
	new_vec.y = new_vec.y - 5
	effect.interpolate_property(sprite,
		'position',
		old_vec,
		new_vec,
		0.3,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN)
	effect.interpolate_property(sprite,
		'scale',
		sprite.get_scale(),
		Vector2(0.12, 0.12),
		0.3,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN)

func can_harm(projectile):
	return $Shield.can_harm(projectile)

func note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
	
	$PolyVoiceCannon.note_off(pitch, velocity, channel)
	
	if cannon_energy < 1.0:
		return
	cannon_energy -= 1.0
	
	$PolyVoiceCannon.note_on(pitch, velocity, channel)
	
	cannon_angle = (pitch - 48) * 10
	charge_start_time = OS.get_ticks_msec()

func note_off(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	$PolyVoiceCannon.note_off(pitch, velocity, channel)
	
	shoot()

func shoot():
	# $Cannon.global_rotation += 3
	var direction = Vector2(0, -200).rotated($Cannon.global_rotation)
	var projectile = preload("res://Player/Projectile.tscn").instance()
	projectile.rotation_degrees = $Cannon.global_rotation_degrees
	projectile.position = direction + position
	get_parent().add_child(projectile)
	projectile.apply_central_impulse(linear_velocity + direction * 5 * max((OS.get_ticks_msec() - charge_start_time) / 200, 1))

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
	
	#if Input.is_action_just_pressed("ui_accept"):
	#	charge_start_time = OS.get_ticks_msec()
	#	shoot()
	
	var velocity = calculate_velocity_from_input(delta)
	
	add_central_force(velocity)
	# move_and_collide (velocity)
	
	$CannonProgress.value = cannon_energy
	$ShieldProgress.value = $Shield.energy
	$MovementProgress.value = movement_energy
	
	shake_amplitude = lerp(shake_amplitude, 0, delta * 3)
	$Camera2D.offset = Vector2(rand_range(-shake_amplitude, shake_amplitude), rand_range(-shake_amplitude, shake_amplitude))
	
	$"UI/Hitpoints".value = hitpoints

func _integrate_forces(state: Physics2DDirectBodyState):
	angular_velocity = 0.0
	rotation = 0.0
	for i in range(state.get_contact_count()):
		var contact = preload("res://contact_particles.tscn").instance()
		contact.position = state.get_contact_local_position(i)
		contact.rotation = state.get_contact_local_normal(i).angle() + PI
		get_parent().add_child(contact)
