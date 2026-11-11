extends Node

const TOTAL_SLOTS = 3

func slot_existe(slot: int) -> bool:
	return FileAccess.file_exists("user://save_%d.save" % slot)

# Salva dados no slot
func salvar(slot: int, dados: Dictionary) -> void:
	dados["timestamp"] = Time.get_datetime_string_from_system()
	var f = FileAccess.open("user://save_%d.save" % slot, FileAccess.WRITE)
	if f:
		f.store_var(dados)
		f.close()
		print("SaveManager: Gravado no slot ", slot, " com dados: ", dados) 
	else:
		push_error("Não foi possível salvar no slot %d" % slot)

func carregar(slot: int) -> Dictionary:
	if not slot_existe(slot):
		return {}
	var f = FileAccess.open("user://save_%d.save" % slot, FileAccess.READ)
	if f:
		var dados = f.get_var()
		f.close()
		return dados
	return {}

# Apaga um slot
func apagar(slot: int) -> void:
	if slot_existe(slot):
		DirAccess.remove_absolute("user://save_%d.save" % slot)
		print("Save do slot ", slot, " apagado")


func info_slot(slot: int) -> String:
	if not slot_existe(slot):
		return "Slot %d — Vazio" % slot
	var dados = carregar(slot)
	var ts = dados.get("timestamp", "?")
	return "Slot %d — %s" % [slot, ts]
