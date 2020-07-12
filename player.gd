extends KinematicBody2D

onready var ControlNode = $CanvasLayer/Control

onready var LabelScore = $CanvasLayer/Control/Score

onready var LabelUp = $CanvasLayer/Control/LabelUp
onready var LabelDown = $CanvasLayer/Control/LabelDown
onready var LabelLeft = $CanvasLayer/Control/LabelLeft
onready var LabelRight = $CanvasLayer/Control/LabelRight

var keyUp:int = 87
var keyDown:int = 83
var keyLeft:int = 65
var keyRight:int = 68
const jump_height:int = 300

var knockback = false

const ACCEL:int = 20
var MAX_SPEED:int = 4000 
var speed = 30

const gravity:int = 1000

var pressedKeys = []
var usedKeys := []

var Velocity:Vector2 = Vector2(5, 0)

var enemys:int = 4
func getScore():
	var my_group_members = get_tree().get_nodes_in_group("enemy")
	if my_group_members == null:
		return
	LabelScore.text = str(my_group_members.size())
	LabelScore.text += "/4"
	if my_group_members.size() == 0:
		get_tree().change_scene("res://credits.tscn")

func _ready():
	print(get_topleft())
	randomize()
	getScore()

func _process(_delta):
	getScore()

func _physics_process(delta):
	#input
	if keyUp in pressedKeys:
		if is_on_floor():
			Velocity.y -= jump_height
#	if keyDown in pressedKeys:
#		Velocity.y += speed
	if keyLeft in pressedKeys:
		Velocity.x = max(-speed + Velocity.x, -MAX_SPEED)
	if keyRight in pressedKeys:
		Velocity.x = min(speed + Velocity.x, MAX_SPEED)
	
	
	
	if !is_on_floor():
		Velocity.y += gravity * delta
		Velocity.x = lerp(Velocity.x, 0, 0.15)
	else:
		Velocity.x = lerp(Velocity.x, 0, 0.3)
#	Velocity = Velocity.normalized() * speed
	if knockback:
		Velocity.x = (Velocity.x + 500) * -1
		knockback = false
	Velocity = move_and_slide(Velocity, Vector2.UP)
	

#This will collect all presed keys!
func _input(event):
	if event is InputEventKey:
		if event.scancode == 16777217:
			get_tree().quit()
		if event.is_pressed():
			if !event.scancode in pressedKeys:
				pressedKeys.append(event.scancode)
		else:
			if event.scancode in pressedKeys:
				pressedKeys.erase(event.scancode)

func get_topleft():
	return OS.get_window_size() / 4 * -1

func SetUi():
	#This should be removed, but it does no harm soooooo.
	ControlNode._set_position(get_topleft())

func randomKeys():
	usedKeys = []
	
	usedKeys.append(keyUp)
	usedKeys.append(keyDown)
	usedKeys.append(keyLeft)
	usedKeys.append(keyRight)
	
	
	var NotDone = true
	var up := true
	var down := true
	var left := true
	var right := true
	
	#this mess will randomise keyboard keys for up, 'down'(ehmm), left and right.
	while NotDone:
		var a = Globals.usableKeys[randi()%Globals.usableKeys.size()]
		
		if a in usedKeys:
			if usedKeys.size() > 20:
				NotDone = false
		elif up:
			LabelUp.text = OS.get_scancode_string(a)
			keyUp = a
			up = false
		elif down:
			LabelDown.text = OS.get_scancode_string(a)
			keyDown = a
			down = false
		elif left:
			LabelLeft.text = OS.get_scancode_string(a)
			keyLeft = a
			left = false
		elif right:
			LabelRight.text = OS.get_scancode_string(a)
			keyRight = a
			right = false
			NotDone = false
		else:
			printerr("Error in script, did not escape the loop, i repeat, i did not escape!")
		usedKeys.append(a)
			

func _on_Timer_timeout():
	randomKeys()
#	LabelRight.text = OS.get_scancode_string(Globals.usableKeys[randi()%Globals.usableKeys.size()])


func _on_fall(n):
	if n == self:
		$Timer.stop()
		$Timer.wait_time = 2
		$Timer.start()

func _on_knockback():
	knockback = true
	randomKeys()
