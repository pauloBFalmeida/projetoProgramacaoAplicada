class_name CartaRes
extends Resource

@export_category("Visual")

@export var nome : String

## Textura
@export var imagem: Texture2D

@export_category("Atributos")
##
@export var nivel_para_desbloquear : int 
##
@export var preco_para_construir : int = 5

# TODO: criar classe com recurso e quanto custa para construir
# TODO: criar classe com recurso e quanto gera, para ter comodos com mais de 1 recurso
@export var recurso_gerado : GerenciadorRecursos.Recurso
