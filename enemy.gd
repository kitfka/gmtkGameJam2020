extends KinematicBody2D


var Velocity:Vector2 = Vector2(5, 0)

const gravity:int = 1000

export var direction:int = -1
var speed:int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")

func _process(delta):
	Velocity.x += speed * direction
	if !is_on_floor():
		Velocity.y += gravity * delta
		Velocity.x = lerp(Velocity.x, 0, 0.15)
	else:
		Velocity.x = lerp(Velocity.x, 0, 0.15)
		
	Velocity = move_and_slide(Velocity, Vector2.UP)


func _on_Area2DTop_body_entered(body):
	if body.has_method("_on_knockback"):
		body.call("_on_knockback")
		queue_free()
	


func _on_Area2DLeft_body_entered(body):
	if body.has_method("_on_knockback"):
		body.call("_on_knockback")


func _on_Timer_timeout():
	direction = direction * -1
	if direction > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")
		
		
		
		
		
		
		
		
