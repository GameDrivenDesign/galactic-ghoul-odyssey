extends RigidBody2D

func _integrate_forces(state: Physics2DDirectBodyState):
	for i in range(state.get_contact_count()):
		var impact_speed = linear_velocity.length() / 60
		var contact = preload("res://hit_particles.tscn").instance()
		contact.position = state.get_contact_local_position(i)
		contact.rotation = state.get_contact_local_normal(i).angle() + PI
		contact.scale = Vector2(impact_speed, impact_speed)
		get_parent().add_child(contact)
		queue_free()