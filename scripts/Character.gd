extends Area2D

@export var speed = 2
var moving = false
var tile_size = 32
var movement_direction = "still"

var inputs = {
	"moveright": Vector2.RIGHT,
	"moveleft": Vector2.LEFT,
	"moveup": Vector2.UP,
	"movedown": Vector2.DOWN,
	"still": Vector2.ZERO
}

@onready var ray = $PointingRay

func _ready():
	#position = position.snapped(Vector2.ONE * tile_size)
	$CharacterSprite/AnimationPlayer.speed_scale = speed

func _input(event):
	if event.is_action_pressed("moveright"):
		movement_direction = "moveright"
	elif event.is_action_pressed("moveleft"):
		movement_direction = "moveleft"
	elif event.is_action_pressed("moveup"):
		movement_direction = "moveup"
	elif event.is_action_pressed("movedown"):
		movement_direction = "movedown"

	if event.is_action_released("moveright"):
		movement_direction = "still"
	elif event.is_action_released("moveleft"):
		movement_direction = "still"
	elif event.is_action_released("moveup"):
		movement_direction = "still"
	elif event.is_action_released("movedown"):
		movement_direction = "still"

func _process(_delta):
	if moving:
		return
	move(movement_direction)

func move(dir):
	if movement_direction != "still":
		ray.target_position = inputs[dir] * tile_size
		ray.force_raycast_update()
		if !ray.is_colliding():
			var movementTween = get_tree().create_tween()
			movementTween.tween_property(self, "position", position + inputs[dir] * tile_size, 0.8 / speed).set_trans(Tween.TRANS_LINEAR)
			moving = true
			$CharacterSprite/AnimationPlayer.play(dir)
			await movementTween.finished
			moving = false
			$CharacterSprite/AnimationPlayer.stop()

