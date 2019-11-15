extends Node

var attack = 0.5
var current = 0.0
var active = false

func play(pitch):
	var c4 = 72
	var offset = pitch - c4
	var pitch_scale = pow(2, (offset / 12.0))
	$aeolia_c4.play()
	$aeolia_c4.pitch_scale = pitch_scale
	$aeolia_c4.set_volume_db(-80)
	active = true
	
func stop():
	active = false
	
func _process(delta):
	if active:
		current = clamp(current + delta/attack, 0.0, 1.0)
	if !active:
		current = clamp(current - delta/attack, 0.0, 1.0)
		
	if current == 0.0:
		$aeolia_c4.stop()
		
	$aeolia_c4.set_volume_db((-1.0 + current) * 100)
	print("----")
	print(current)
	print($aeolia_c4.volume_db)