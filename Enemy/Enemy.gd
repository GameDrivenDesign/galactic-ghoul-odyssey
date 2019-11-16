extends KinematicBody2D

var hitpoints = 10

const COLORS = [Color(1, 0, 0), Color(0, 1, 0), Color(1, 1, 0)]
var attack_color = Color(1, 0, 0)

#func _integrate_forces(state):
#	var player_position: Vector2 = get_node('../Player').position
#	var delta = player_position - position
#	#if abs(delta.angle()) < 0.4:
#	#	add_central_force(Vector2(0, 100))
#	add_torque(position.angle_to_point(player_position) * 10)

func _ready():
	_on_change_color_timeout()

func _physics_process(delta):
	var player_position: Vector2 = get_node('../Player').position
	var direction = player_position - position
	rotation = lerp(rotation, position.angle_to_point(player_position) + PI / 2, delta * 10)
	if direction.length() > 400:
		move_and_collide(Vector2(0, 10).rotated(rotation))

func _on_shoot_timeout():
	var direction = Vector2(0, 120).rotated(rotation)
	var projectile = preload("res://Player/Projectile.tscn").instance()
	projectile.rotation = rotation + PI
	projectile.position = position + direction
	projectile.set_projectile_color(attack_color)
	get_parent().add_child(projectile)
	projectile.apply_central_impulse(Vector2(0, -2000).rotated(rotation + PI))


func _on_change_color_timeout():
	attack_color = COLORS[randi() % COLORS.size()]
