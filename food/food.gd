extends Area2D
var min_scale = 1
var max_scale = 1.2
var food_name


func _ready():
	scale_sprite(min_scale)



func init_food(name, texture):
	food_name = name
	$Sprite.texture = texture
	$Sprite.visible = true
	

func _on_food_mouse_entered():
	scale_sprite(max_scale)
	$Hover.play()


func _on_food_mouse_exited():
	scale_sprite(min_scale)


func _on_food_input_event(_viewport, event, _shape_idx):
	if not event is InputEventMouseButton: return
	if event.button_index != BUTTON_LEFT: return
	if not event.is_pressed(): return
	
	$Click.play()
	EventHub.emit_signal("food_clicked", food_name)
	queue_free()


func scale_sprite(scale_factor):
	$Sprite.scale.x = scale_factor
	$Sprite.scale.y = scale_factor
