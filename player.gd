extends KinematicBody2D

var gravity = -100

var vel = Vector2(0, 0)
var acc = 10
var max_speed = 150

func _ready():
	pass


func _process(_delta):
	control()
	
	vel.y -= gravity
	
	vel = move_and_slide(vel)


func control():
	if Input.is_action_pressed("ui_right"):
		vel.x = min(vel.x+acc, max_speed)
	elif Input.is_action_pressed("ui_left"):
		vel.x = max(vel.x-acc, -max_speed)
	else: 
		vel.x = lerp(vel.x, 0, 0.2)
	if Input.is_action_just_pressed("ui_select") and is_on_wall():
		vel.y = -2000
