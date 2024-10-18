@tool
extends Area2D

var carregador: Global.Carregador = Global.Carregador.create(0, 0, 0) :
	set(new_carregador):
		carregador = new_carregador
		$Container/Quantidade/Value.text = "%d/%d" % [carregador.quantidade, carregador.capacidade]
		$Container/Massa/Value.text = "%.01fg" % carregador.massa

@export var tipo_carregador: Global.TipoCarregador :
	set(novo_tipo):
		$Polygon2D.color = Global.cor_do_tipo[novo_tipo]
		tipo_carregador = novo_tipo

func _get_property_list():
	var properties:  Array[Dictionary] = [{
			"name": "c_capacidade",
			"type": TYPE_INT
	},
	{
			"name": "c_quantidade",
			"type": TYPE_INT
	},
	{
			"name": "c_massa",
			"type": TYPE_FLOAT
	}]
	
	return properties

func _get(property):
	if property.begins_with("c_"):
		var key = property.get_slice("_", 1)
		return carregador[key]

func _set(property, value):
	if property.begins_with("c_"):
		var key = property.get_slice("_", 1)
		carregador[key] = value
		if key == "capacidade":
			if carregador.quantidade > value:
				carregador.quantidade = value
			if $Container:
				$Container/Quantidade/Value.text = "%d/%d" % [carregador.quantidade, carregador.capacidade]
		elif key == "quantidade":
			if carregador.capacidade < value:
				carregador.capacidade = value
			if $Container:
				$Container/Quantidade/Value.text = "%d/%d" % [carregador.quantidade, carregador.capacidade]
		elif key == "massa":
			if $Container:
				$Container/Massa/Value.text = "%.01fg" % carregador.massa
		return true
	return false

var hovering_gun = null :
	set(new_value):
		print(new_value)
		if new_value:
			$Container.visible = true
		else:
			$Container.visible = false
		hovering_gun = new_value

func _input(event: InputEvent) -> void:
	if hovering_gun and event.is_action_pressed("use"):
		var old_carregador = hovering_gun.carregador
		hovering_gun.carregador = carregador
		carregador = old_carregador
		hovering_gun = null
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var gun = body.guns[body.active_gun]
		if gun.tipo_carregador == tipo_carregador:
			hovering_gun = gun


func _on_body_exited(body: Node2D) -> void:
	hovering_gun = null
