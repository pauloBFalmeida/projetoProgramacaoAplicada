class_name CartaRes
extends Resource

@export_category("Visual")

@export var nome : String

## Textura
@export var imagem: Texture2D

@export_category("Atributos Desbloqueio")
##
@export var nivel_desbloqueio : int = 1
##
@export var preco_desbloqueio := GerenciadorRecursos.Qntd.BAIXO

@export_category("Atributos Geração")

@export var recurso_recebido : Dictionary[GerenciadorRecursos.Recurso, GerenciadorRecursos.Qntd] = {}

@export var recurso_gerado : Dictionary[GerenciadorRecursos.Recurso, GerenciadorRecursos.Qntd] = {}
