extends KinematicBody2D

var random = RandomNumberGenerator.new()

var gravity = 100
var vel = Vector2()
var acc = 10
var max_speed = 100

var flag = 0

# is block direction
var npc_direction = 0 # 0 sag 1 sol
var is_block_right = 0
var is_block_left = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize() # Npc dunyaya eklendiginde random sayi ureten seed i degistirecek
	check_around()


func _process(_delta):
	move() # NPC nin hareketlerini kontrol edecek.
	#doom() # O anda icinde bulundugu duruma gore ne yapacagina karar verir.
	
	# Gravity
	vel.y -= -gravity
	vel = move_and_slide(vel)


func change_direction(directionParam=0):
	if directionParam == 1:
		pass
	elif directionParam == 2:
		pass
	else:
		# SAG
		if random.randi_range(0, 100) > 50:
			npc_direction = 0
			
			$Area2D/player_detect.position.x = 256 # NPC saga bakacak
			$Area2D/Sprite.position.x = 256
			$wall_detected/CollisionShape2D.position.x = 48
			
			if random.randi_range(0, 100) > 50:
				$move_timer.start(3)
				flag = 1
				if is_block_right:
					print("Saga zipladim")
					jump(0)
		# SOL
		else:
			npc_direction = 1
			
			$Area2D/player_detect.position.x = -256 # NPC sola bakacak
			$Area2D/Sprite.position.x = -256
			$wall_detected/CollisionShape2D.position.x = -48
			
			if random.randi_range(0, 100) < 50:
				$move_timer.start(3)
				flag = 2
				if is_block_left:
					print("Sola zipladim")
					jump(1)


#=================== BAGLI FONKSIYONLAR
func check_around():
	change_direction()


func _on_Timer_timeout():
	print("timer sonlandi")
	check_around() # NPC timer sonlandiginda saga veya sola bakacak rastgele olarak
#=================== ustteki ikisi etrafi kontrol icin

func jump(direction=2):
	if is_on_wall():
		vel.y = -2000
		if direction == 0: # Saga ziplayacak
			flag = 1
		elif direction == 1: # Sola ziplayacak
			flag = 2
		


func move():
	if flag: # flag 0 dan farkli ise if icine girecek.
		if flag == 1: # NPC saga gider
			vel.x = min(vel.x+acc, max_speed)
		elif flag == 2: # NPC sola gider
			vel.x = max(vel.x-acc, -max_speed)
		elif flag == 3: # NPC yavasca durur.
			vel.x = lerp(vel.x, 0, 0.2)
		elif flag == 4 and is_on_wall(): # NPC eger yerdeyse ziplar
			jump()
	else:
		flag = 3


#func doom():
#	if is_see_player:
#		if player_pos > npc_pos: # playerin ne tarafta oldugunu anlamak icin
#			flag = 1
#		else: flag = 2


func _on_Area2D_body_entered(_body):
#	if body.collision_layer == 2:
#		is_see_player = 1
#		npc_pos = position.x
#		player_pos = body.position.x
	pass


func _on_Area2D_body_exited(_body):
#	if body.collision_layer == 2:
#		is_see_player = 0
#		player_escape = 1
#		flag = 3
	pass


func _on_move_timer_timeout():
	print("Npc durdu")
	flag = 3
	$Timer.start()


func _on_wall_detected_body_entered(_body):
	print("Duvarla karsilastim")
	flag = 3
	$Timer.start()
	
	if npc_direction == 0:
		is_block_right = 1
	elif npc_direction == 1:
		is_block_left = 1


func _on_wall_detected_body_exited(_body):
	is_block_right = 0
	is_block_left = 0
