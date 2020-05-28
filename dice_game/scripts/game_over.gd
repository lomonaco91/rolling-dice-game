extends Node2D

func _ready():
	pass 

#Botão para sair do jogo
func _on_exit_pressed():
	get_tree().quit()

#Botão para jogar novamente
func _on_playAgain_pressed():
	get_tree().change_scene("res://scenes/game.tscn")
