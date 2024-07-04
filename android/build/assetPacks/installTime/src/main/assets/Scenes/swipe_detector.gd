extends Camera2D
class_name SwipeDetector

signal swipe_detected(direction: String)

var length = 50
var startPos: Vector2
var curPos: Vector2
var swiping: bool = false
var joystick_on: bool = false

var threshold = 55
@onready var mobile_joystick = $"../MobileJoystick"

func _process(delta):
	if joystick_on == false:
		if Input.is_action_just_pressed("press"):
			if !swiping:
				swiping = true
				startPos = get_global_mouse_position()
				
		if Input.is_action_pressed("press"):
			curPos = get_global_mouse_position()
			if startPos.distance_to(curPos) >= length:
				if (startPos.y - curPos.y) <= -threshold:
					emit_signal("swipe_detected", "down")
					swiping = false
				elif (startPos.y - curPos.y) >= threshold:
					emit_signal("swipe_detected", "up")
					swiping = false
				elif (startPos.x - curPos.x) <= -threshold:
					emit_signal("swipe_detected", "right")
					swiping = false
				elif (startPos.x - curPos.x) >= threshold:
					emit_signal("swipe_detected", "left")
					swiping = false
		else:
			swiping = false

func _on_mobile_joystick_joystick_pressed():
	joystick_on = true

func _on_mobile_joystick_joystick_released():
	joystick_on = false

func _on_action_release_timer_timeout():
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("up")
	Input.action_release("down")
