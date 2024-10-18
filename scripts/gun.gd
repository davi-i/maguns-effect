@tool
extends Node2D
class_name Gun

var bullet = preload("res://scenes/bullet.tscn")

var tipo_carregador: Global.TipoCarregador :
	set(novo_tipo):
		if $Polygon2D:
			$Polygon2D.color = Global.cor_do_tipo[novo_tipo]
		tipo_carregador = novo_tipo


func _get_property_list():
	var properties:  Array[Dictionary] = [{
	  &'name': &'tipo_carregador',
	  &'type': TYPE_INT,
	  &'hint': PROPERTY_HINT_ENUM,
	  &'hint_string': ','.join(Global.TipoCarregador.keys().map(func(key): return key.to_lower()))
  }]
	
	return properties

var carregador: Global.Carregador = Global.Carregador.create(10, 10, 0.2) :
	set(new):
		carregador = new
		Global.gun_changed.emit(self)

var backspin_drag = .5
var full_auto = false

func shoot():
	if carregador.quantidade > 0 and $ShootDelay.is_stopped():
		var new_bullet = bullet.instantiate()
		new_bullet.backspin_drag = backspin_drag
		new_bullet.massa = carregador.massa
		$BulletMarker.add_child(new_bullet)
		new_bullet.apply_impulse(Vector2(1 / new_bullet.mass, 0).rotated(global_rotation))
		carregador.quantidade -= 1
		Global.gun_changed.emit(self)
		$ShootDelay.start()

func kill_bullets():
	for bullet in $BulletMarker.get_children():
		bullet.queue_free()
