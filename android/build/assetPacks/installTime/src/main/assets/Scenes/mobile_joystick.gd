extends CanvasLayer

var move_vector = Vector2(0, 0)
var joystick_active = false
var joystick_radius = 50

@onready var touch_screen_button = $TouchScreenButton
@onready var joyfront = $Joyfront

signal joystick_pressed
signal joystick_released

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if touch_screen_button.is_pressed():
			joystick_active = true
			var clamped_position = calculate_clamped_position(event.position)
			joyfront.position = clamped_position
			joyfront.visible = true
			
			move_vector = calculate_move_vector(clamped_position)
			handle_move_vector(move_vector)
			
			emit_signal("joystick_pressed")
			
		if event is InputEventScreenTouch:
			if event.pressed == false:
				joystick_active = false
				joyfront.visible = false
				emit_signal("joystick_released")

func calculate_clamped_position(event_position):
	var texture_center = touch_screen_button.position + Vector2(70, 70)
	var offset = event_position - texture_center
	if offset.length() > joystick_radius:
		offset = offset.normalized() * joystick_radius
	return texture_center + offset

func calculate_move_vector(clamped_position):
	var texture_center = touch_screen_button.position + Vector2(70, 70)
	return (clamped_position - texture_center).normalized()

func handle_move_vector(move_vector):
	if abs(move_vector.x) > abs(move_vector.y):
		if move_vector.x > 0:
			Input.action_press("right")
			Input.action_release("left")
			Input.action_release("up")
			Input.action_release("down")
		else:
			Input.action_press("left")
			Input.action_release("right")
			Input.action_release("up")
			Input.action_release("down")
	else:
		if move_vector.y > 0:
			Input.action_press("down")
			Input.action_release("up")
			Input.action_release("left")
			Input.action_release("right")
		else:
			Input.action_press("up")
			Input.action_release("down")
			Input.action_release("left")
			Input.action_release("right")
