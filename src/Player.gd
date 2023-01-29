extends Area2D
signal hit

# export lets us set the value in inspector (same as public in unity)
export var speed = 400
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size

# Called when the node enters the scene tree for the first time. (Start in Unity)
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame. (update in Unity)
func _process(delta):
	var velocity = Vector2.ZERO # set velocity to (0,0)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # normalize so we don't move faster diagonally
		$AnimatedSprite.play() # $ is shorthand for get node
	else:
		$AnimatedSprite.stop()
	
	# handles the movement of the player
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x) # clamp to keep it within the screen
	position.y = clamp(position.y, 0, screen_size.y)
	
	# handle the animation of the player
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true) # disable the players collision when safe to do so
