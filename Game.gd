extends Node2D

func _ready():
	while true:
		spawn_comets_nearby()
		yield (get_tree().create_timer(8), "timeout")
		#spawn_enemy_nearby()

func spawn_enemy_nearby():
	var enemy = preload("res://Enemy/Enemy.tscn").instance()
	enemy.position = $Player.position + Vector2(rand_range(2000, 6000), 0).rotated(rand_range(0, 2 * PI))
	add_child(enemy)

func spawn_comets_nearby():
	var Comet = preload("res://Comet.tscn")
	for i in range(10):
		var comet = Comet.instance()
		comet.position = $Player.position + Vector2(rand_range(2000, 6000), 0).rotated(rand_range(0, 2 * PI))
		comet.rotation_degrees = rand_range(0, 360)
		add_child(comet)
