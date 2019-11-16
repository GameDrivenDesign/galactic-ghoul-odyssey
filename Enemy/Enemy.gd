extends KinematicBody2D

func _ready():
	pass

#func _integrate_forces(state):
#	var player_position: Vector2 = get_node('../Player').position
#	var delta = player_position - position
#	#if abs(delta.angle()) < 0.4:
#	#	add_central_force(Vector2(0, 100))
#	add_torque(position.angle_to_point(player_position) * 10)

func _physics_process(delta):
	var player_position: Vector2 = get_node('../Player').position
	var direction = player_position - position
	rotation = lerp(rotation, position.angle_to_point(player_position) + PI / 2, delta * 10)
	move_and_collide(Vector2(0, 10).rotated(rotation))

func _on_shoot_timeout():
	var direction = Vector2(0, 120).rotated(rotation)
	var projectile = preload("res://Player/Projectile.tscn").instance()
	projectile.rotation = rotation + PI
	projectile.position = position + direction
	get_parent().add_child(projectile)
	projectile.apply_central_impulse(Vector2(0, -2000).rotated(rotation + PI))