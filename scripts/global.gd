extends Node

enum TipoCarregador {
	SHOTGUN,
	RIFLE,
	PISTOLA
}

const cor_do_tipo = {
	TipoCarregador.SHOTGUN: Color.RED,
	TipoCarregador.RIFLE: Color.BLUE,
	TipoCarregador.PISTOLA: Color.GREEN
}

class Carregador:
	var capacidade: int
	var quantidade: int
	var massa: float

	static func create(capacidade: int, quantidade: int, massa: float) -> Carregador:
		var carregador = Carregador.new()
		carregador.capacidade = capacidade
		carregador.quantidade = quantidade
		carregador.massa = massa
		return carregador

signal gun_changed(gun: Gun)

@onready var container = $CanvasLayer/VBoxContainer

func _on_gun_changed(gun: Gun) -> void:
	container.get_node("Massa/Value").text = "%.01fg" % gun.carregador.massa
	container.get_node("Quantidade/Value").text = "%d/%d" % [gun.carregador.quantidade, gun.carregador.capacidade]
	container.get_node("HopUp/Value").text = "%.02f" % gun.backspin_drag
	container.get_node("FullAuto/Value").text = "Ativado" if gun.full_auto else "Desativado"
