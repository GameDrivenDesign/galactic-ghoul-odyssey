extends RigidBody2D

var projectile_color: Color

func _integrate_forces(state: Physics2DDirectBodyState):
	for i in range(state.get_contact_count()):
		var did_damage = false
		
		var collider = state.get_contact_collider_object(i)
		if collider and collider.get("hitpoints") != null:
			if !collider.has_method("can_harm") or collider.can_harm(self):
				if collider.has_method("add_shake"):
					collider.add_shake(5)
				collider.hitpoints -= 1
				did_damage = true
				if collider.hitpoints <= 0:
					collider.queue_free()
		
		if did_damage:
			var impact_speed = min(linear_velocity.length() / 60, 2)
			var contact = preload("res://hit_particles.tscn").instance()
			contact.position = state.get_contact_local_position(i)
			contact.rotation = state.get_contact_local_normal(i).angle() + PI
			contact.scale = Vector2(impact_speed, impact_speed)
			get_parent().add_child(contact)
		
		queue_free()

func set_projectile_color(color: Color):
	$Sprite.modulate = color
	$Particles2D.modulate = color
	projectile_color = color
