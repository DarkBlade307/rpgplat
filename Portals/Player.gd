extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 2
const MAXFALLSPEED = 100
const MAXSPEED = 30
const JUMPFORCE = 60

var facing_right = true

var motion = Vector2()

func _ready():
	pass
	
func _physics_process(delta):
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_pressed("right"):
		facing_right = true
		$AnimationPlayer.play("MoveRight")
		motion.x = MAXSPEED
	elif Input.is_action_pressed("left"):
		facing_right = false
		$AnimationPlayer.play("MoveLeft")
		motion.x = -MAXSPEED
	else:
		motion.x = 0
		$AnimationPlayer.play("Idle")
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
	else:
		if facing_right == true:
			$AnimationPlayer.play("AirRight")
		elif facing_right == false:
			$AnimationPlayer.play("AirLeft")
			
	motion = move_and_slide(motion, UP)
