extends Node

func play(pitch):
	var c4 = 72
	var offset = pitch - c4
	var pitch_scale = pow(2, (offset / 12.0))
	$aeolia_c4.play()
	$aeolia_c4.pitch_scale = pitch_scale
	
func stop():
	$aeolia_c4.stop()