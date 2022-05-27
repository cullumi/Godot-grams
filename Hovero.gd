extends KinematicBody2D

export (float, 2, 50) var speed:float = 5
export (float, 50, 500) var limit:float = 500

var dragging:bool = false
var velocity:Vector2 = Vector2()

func _unhandled_input(event):
	if event.is_action_pressed("hover"):
		dragging = true
	elif event.is_action_released("hover"):
		dragging = false
		velocity = Vector2()

func _physics_process(delta):
	if dragging:
		var mouse_pos = get_local_mouse_position()
		velocity = mouse_pos * mouse_pos
		velocity *= delta * speed
		velocity.x = min(velocity.x, limit)
		velocity.y = min(velocity.y, limit)
		velocity *= mouse_pos.sign()
		
		move_and_slide(velocity)
