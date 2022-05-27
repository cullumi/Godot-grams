extends Node2D

var overview = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("camera"):
		overview = not overview
		$Overcam.current = overview
		$Hovero/HoverCam.current = not overview
