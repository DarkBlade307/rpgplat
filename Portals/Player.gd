extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 2
const MAXFALLSPEED = 100
const MAXSPEED = 30
const JUMPFORCE = 65

signal health_updated(health)
signal killed()

var facing_right = true
var prev_air = false

export (float) var max_hp = 100

onready var health = max_hp
onready var iFrame = $Timer

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
		prev_air = false
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
	else:
		if prev_air == false:
			if facing_right == true:
				$AnimationPlayer.play("AirRight")
			elif facing_right == false:
				$AnimationPlayer.play_backwards("AirLeft")
			prev_air = false
		prev_air = false
			
	motion = move_and_slide(motion, UP)


func _on_DeathArea_body_entered(body):
	if str(body) == "Player:[KinematicBody2D:1301]":
		pass # Kill player code goes here
		
func kill():
	pass
	
func damage(amount):
	if iFrame.is_stopped():
		iFrame.start()
		set_health(health - amount)
		
func set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_hp)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal('killed')
