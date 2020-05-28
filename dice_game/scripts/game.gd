extends Node2D

#Variáveis globais
var rnd = 1
var srtValue = 0
var rlDice = 0
var wrong = 0
var right = 0
var totalValue = 0
var totalValueFinal = 0
var multiplier
onready var timer = get_node("canvas_bg/timerNewRound")
onready var timerGameOver = get_node("canvas_bg/timerGameOver")

#Construtor/Quando inicializa a tela
func _ready():
	generateRandomDice() #Quando inicia a tela, gera o valor do dado randomicamente
	get_node("canvas_bg/errorsPoints").text = str(wrong) #inicializando a quantidade de erros
	get_node("canvas_bg/successPoints").text = str(right) #inicializando a quantidade de acertos
	get_node("canvas_bg/correctIMG").visible = false #inicializa a img de correto como falso
	get_node("canvas_bg/incorrectIMG").visible = false #inicializa a img de correto como falso
	get_node("canvas_bg/gameTotalPoints").text = str(totalValue) #inicializa o total de pontos
	get_node("canvas_bg/bonusLabel").visible = false # oculta o campo de bônus do multiplicador
	get_node("canvas_bg/bonusLabelValue").visible = false # oculta o valor do bônus
	pass

#Botão nova rodada
func newRound():
	print('Rodada atual ? -> ', rnd)
	#Verifica se a rodada atual é menor que 10
	if(rnd < 10):
		generateRandomDice() #Sorteia randomicamente o valor do dado entre 1-6
		rnd = rnd + 1 #Incrementa a rodade atual
		get_node("canvas_bg/roundTime").text = str(rnd) #Exibe a rodada atual
		get_node("canvas_bg/correctIMG").visible = false #Oculata a imagem de acerto
		get_node("canvas_bg/incorrectIMG").visible = false #Oculta a imagem de erro
		get_node("canvas_bg/roleDiceValue").text = str('') # Zera o valor do dado rolado
		get_node("canvas_bg/sumValue").text = str('') # Zera o valor de verificação da soma
		get_node("canvas_bg/bonusLabel").visible = false # oculta o campo de bônus quando acerta
		get_node("canvas_bg/bonusLabelValue").visible = false # oculta o valor multiplicador do bônus quando acerta
		get_node("canvas_bg/bonusLabelValue").text = str('') # seta o valor do bônus multiplicador
	
	elif(rnd >= 10):
		get_node("canvas_bg/checkValue").disabled = true
		
		#Espera 2 segundos p/ verificar que acabou e mandar para a tela de game-over
		timerGameOver.set_wait_time(2)
		timerGameOver.start()

#Botão de rolar os dados
func _on_roleDice_pressed():
	rlDice = randi() % 7
	get_node("canvas_bg/roleDiceValue").text = str(rlDice)

#Função para gerar o valor do dado randomicamente
func generateRandomDice():
	srtValue = randi() % 7
	get_node("canvas_bg/sortValue").text = str(srtValue)

#Botão para verificar a soma dos valores
func _on_checkValue_pressed():
	var chk = str(srtValue + rlDice)
	var chkField = str(get_node("canvas_bg/sumValue").text)
	#Compara os valores
	if(chk == chkField):
		#Valores iguais
		get_node("canvas_bg/correctIMG").visible = true # mostra imagem de sucesso
		right = (right+1) #incrementa o acerto
		get_node("canvas_bg/successPoints").text = str(right) #seta o valor incrementada no view
		totalValue = (totalValue + 10) #Incrementa 10 pontos de sucesso		
		multiplier = randi() % 5 # gera o valor multiplicador do acerto de 0-4
		print('Total --> ', totalValue)
		print('Bonus --> ', multiplier)
		get_node("canvas_bg/bonusLabel").visible = true # exibe o campo de bônus quando acerta
		get_node("canvas_bg/bonusLabelValue").visible = true # exibe o valor multiplicador do bônus quando acerta
		get_node("canvas_bg/bonusLabelValue").text = str(multiplier) # seta o valor do bônus multiplicador
		
		#Verifica se o multiplicador não é diferente de zero
		if(multiplier != 0):
			totalValue = (totalValue * multiplier) #Tem bônus do multiplicador
			
		elif(multiplier == 0):
			totalValue = totalValue #não tem o bônus do multiplicador
			
		#Valor final dos pontos
		totalValueFinal += totalValue
		get_node("canvas_bg/gameTotalPoints").text = str(totalValueFinal) # seta total de pontos incrementado com o bônus
		
		#Espera 2 segundos e inicia uma nova rodada
		timer.set_wait_time(0.8)
		timer.start()
		
	elif(chk != chkField):
		#Valores diferentes
		get_node("canvas_bg/incorrectIMG").visible = true # mostra imagem de erro
		wrong = (wrong+1) #incrementa o erro
		get_node("canvas_bg/errorsPoints").text = str(wrong) # seta o valor na view
		
		#Espera 2 segundos e inicia uma nova rodada
		timer.set_wait_time(0.8)
		timer.start()

func _on_timerNewRound_timeout():
	timer.stop() # para o timer p/ não ficar executando N vezes
	newRound() # executa a função de iniciar uma nova rodada

func _on_timerGameOver_timeout():
	get_tree().change_scene("res://scenes/game_over.tscn")

# Botão para sair da aplicação
func _on_exitGame_pressed():
	get_tree().change_scene("res://scenes/menu.tscn")
