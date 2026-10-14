class_name CartaRes
extends Resource

@export_category("Visual")

@export var nome : String

## Textura
@export var imagem: Texture2D

@export_category("Atributos Desbloqueio")
##
@export var nivel_desbloqueio : int 
##
@export var preco_desbloqueio : int = 5

@export_category("Atributos Construção")

@export var recurso_construcao : Dictionary[GerenciadorRecursos.Recurso, int] = {
	GerenciadorRecursos.Recurso.MOEDAS: 50
}

@export var recurso_gerado : Dictionary[GerenciadorRecursos.Recurso, int] = {
	GerenciadorRecursos.Recurso.MOEDAS: 10
}
