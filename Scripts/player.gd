extends CharacterBody2D

enum estados {
	idle,
	andar,
	pular,
	cair,
	agachar,
	# deslizar,
	nadar,
	morrer
}

enum estados_vida {
	grande,
	pequeno
}

@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var recarregar_cena: Timer = $recarregar_cena
@onready var tela_morrer: Sprite2D = $"../../tela_morrer/tela_morrer"
@onready var tempo_fase_contador: Timer = $tempo_fase_contador
@onready var hud: CanvasLayer = $"../../hud"
@onready var mario_cogumelo: AudioStreamPlayer = $sons/MarioCogumelo
@onready var mario_moeda: AudioStreamPlayer = $sons/MarioMoeda
@onready var mario_morte: AudioStreamPlayer = $sons/MarioMorte

@export var velocidade = 150
@export var forca_pulo = -300
@export var aceleracao = 1000
@export var desaceleracao = 1000
@export var max_pulos = 1
@export var tempo_fase = 200

var direcao = 1
var pulo_count = 0
var estado_vida: estados_vida 

var ganhou_fase = false

var status = estados

func _ready() -> void:
	verificar_estado_mario()
	go_to_idle_state()
	Global.tempo_fase = tempo_fase

func _process(_delta: float) -> void:
	if ganhou_fase == true:
		if is_on_floor():
			set_physics_process(false)
			set_process_input(false)
			if estado_vida == estados_vida.grande:
				animacao.play("v	itoria")
			elif estado_vida == estados_vida.pequeno:
				animacao.play("vitoria_pequeno")

func _physics_process(delta: float) -> void:
	match status:
		estados.idle:
			idle_state(delta)
		estados.andar:
			andar_state(delta)
		estados.pular:
			pular_state(delta)
		estados.cair:
			cair_state(delta)
		estados.agachar:
			agachar_state(delta)
		estados.nadar:
			nadar_state(delta)
		estados.morrer:
			morrer_state(delta)
	
	move_and_slide()

func go_to_idle_state():
	status = estados.idle
	set_estado_mario("idle")
func idle_state(delta):
	gavidade(delta)
	
	move(delta)
	
	if Input.is_action_just_pressed("pular"):
		go_to_pular_state()
		return
	
	if velocity.x != 0:
		go_to_andar_state()
		return
	
	if Input.is_action_pressed("agachar"):
		go_to_agachar_state()
		return
	
	if !is_on_floor() and velocity.y > 0:
		go_to_cair_state()
		return

func go_to_andar_state():
	status = estados.andar
	set_estado_mario("andar")
func andar_state(delta):
	gavidade(delta)
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("pular"):
		go_to_pular_state()
		return
		
	if !is_on_floor() and velocity.y > 0:
		pulo_count += 1
		go_to_cair_state()
		return
	
	if Input.is_action_just_pressed("agachar"):
		go_to_agachar_state()
		velocity.x = 0
		return

func go_to_pular_state():
	status = estados.pular
	set_estado_mario("pular")
	velocity.y = forca_pulo
	pulo_count += 1 
func pular_state(delta):
	gavidade(delta)
	move(delta)
	
	if Input.is_action_just_pressed("pular") && pulo_count < max_pulos:
		go_to_pular_state()
		return
		
	if velocity.y > 0:
		go_to_cair_state()
		return
	
	if Input.is_action_just_pressed("agachar"):
		velocity.x = 0
		go_to_agachar_state()
		return

func go_to_cair_state():
	status = estados.cair
	set_estado_mario("cair")
func cair_state(delta):
	gavidade(delta)
	move(delta)
	
	if Input.is_action_just_pressed("pular") && pulo_count < max_pulos:
		go_to_pular_state()
		return
	
	if is_on_floor():
		pulo_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_andar_state()
		return
	
	if Input.is_action_just_pressed("agachar"):
		velocity.x = 0
		go_to_agachar_state()
		return

func go_to_agachar_state():
	status = estados.agachar
	set_estado_mario("agachar")
	colisao.shape.height = 16
	colisao.position.y = 8
	hitbox.shape.size.y = 15
	hitbox.position.y = 8.5
func exit_from_agachar_state():
	if estado_vida == estados_vida.grande:
		hitbox.shape.size.y = 28
		hitbox.position.y = 2
		colisao.shape.height = 28
		colisao.position.y = 2
	elif estado_vida == estados_vida.pequeno:
		colisao.shape.height = 20
		colisao.position.y = 6
		hitbox.shape.size.y = 20
		hitbox.position.y = 6
func agachar_state(delta):
	gavidade(delta)
	update_direction()
	if Input.is_action_just_released("agachar"):
		exit_from_agachar_state()
		go_to_idle_state()
		return
	gavidade(delta)
	update_direction()
	if Input.is_action_just_released("agachar"):
		exit_from_agachar_state()
		go_to_idle_state()
		return

func go_to_morrer_state():
	if status == estados.morrer:
		return
	
	status = estados.morrer
	animacao.play("morrer")
	mario_morte.play()
	velocity = Vector2.ZERO
	global_position.y = global_position.y - 10
	if Global.vidas > 0:
		Global.vidas -= 1
		if Global.moedas < 10:
			Global.moedas = 0
		else:
			Global.moedas -= 10
		if Global.pontos <= 50:
			Global.pontos = 0
		else:
			Global.pontos -= 50
		await get_tree().create_timer(0.5, true, true).timeout
		hud.visible = false
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(tela_morrer, "modulate:a", 1, 1)
		await tween.finished
		await get_tree().create_timer(0.5, true, true).timeout
		recarregar_cena.start()
	else:
		await get_tree().create_timer(0.5, true, true).timeout
		hud.visible = false
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(tela_morrer, "modulate:a", 1, 1)
		await tween.finished
		await get_tree().create_timer(0.5, true, true).timeout
		get_tree().change_scene_to_file("res://Cenas/derrota.tscn")
func morrer_state(_delta):
	Global.status = Global.estados_vida_player.grande

func go_to_nadar_state():
	status = estados.nadar
	set_estado_mario("nadar")
	velocity.y = min(velocity.y, 120)
func nadar_state(delta):
	update_direction()
	
	if direcao:
		velocity.x = move_toward(velocity.x, 100 * direcao, 200 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, 200 * delta)
	
	velocity.y += 80 * delta
	velocity.y = min(velocity.y, 100)
	
	if Input.is_action_just_pressed("pular"):
		velocity.y = -100

func move(delta):
	update_direction()
	
	if direcao:
		velocity.x = move_toward(velocity.x, direcao * velocidade, aceleracao * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, desaceleracao * delta)
func gavidade(delta): 
	if not is_on_floor():
		velocity += get_gravity() * delta
func update_direction():
	direcao = Input.get_axis("esquerda", "direita")
	if direcao < 0:
		animacao.flip_h = true
	elif direcao > 0:
		animacao.flip_h = false

func trocar_hitbox_grande():
	hitbox.shape.size.y = 28
	hitbox.position.y = 2
	colisao.shape.height = 28
	colisao.position.y = 2
func trocar_hitbox_pequeno():
	colisao.shape.height = 20
	colisao.position.y = 6
	hitbox.shape.size.y = 20
	hitbox.position.y = 6
func set_estado_mario(anim):
	if estado_vida == estados_vida.grande:
		trocar_hitbox_grande()
		animacao.play(anim)
	elif estado_vida == estados_vida.pequeno:
		trocar_hitbox_pequeno()
		animacao.play(anim + "_pequeno")
func verificar_estado_mario():
	if Global.status == estados_vida.grande:
		estado_vida = estados_vida.grande
	elif Global.status == estados_vida.pequeno:
		estado_vida = estados_vida.pequeno
func ganhar_moeda():
	mario_moeda.play()
	Global.moedas += 1
	Global.pontos += 10
func dano_inimido(area: Area2D):
	if velocity.y > 0 and status != estados.nadar:
		area.get_parent().levar_dano()
		Global.pontos += 10
		go_to_pular_state()
	else:
		if estado_vida == estados_vida.grande:
			Global.status = Global.estados_vida_player.pequeno
			estado_vida = estados_vida.pequeno
			if status == estados.nadar:
				position.x -= 10 * direcao
				go_to_nadar_state()
			else:
				go_to_pular_state() 
		elif estado_vida == estados_vida.pequeno:
			go_to_morrer_state()
func ganhar_vida():
	mario_cogumelo.play()
	if estado_vida == estados_vida.pequeno:
		animacao.play("ganhar_vida")
		Global.status = Global.estados_vida_player.grande
		estado_vida = estados_vida.grande
		await animacao.animation_finished
		if status == estados.nadar:
			go_to_nadar_state()
	elif estado_vida == estados_vida.grande:
		Global.vidas += 1
		Global.pontos += 100
func ganhar_fase():
	ganhou_fase = true

func _on_recarregar_cena_timeout() -> void:
	get_tree().reload_current_scene()
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("inimigos"):
		dano_inimido(area)
	if area.is_in_group("cogumelo_vida"):
		area.queue_free()
		ganhar_vida()
	if area.is_in_group("agua"):
		go_to_nadar_state()
	if area.is_in_group("projeteis"):
		if estado_vida == estados_vida.grande:
			Global.status = Global.estados_vida_player.pequeno
			estado_vida = estados_vida.pequeno
			if status == estados.nadar:
				position.x -= 10 * direcao
				go_to_nadar_state()
			else:
				go_to_pular_state() 
		elif estado_vida == estados_vida.pequeno:
			go_to_morrer_state()
func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("agua"):
		pulo_count = 0
		go_to_pular_state()

func _on_tempo_fase_contador_timeout() -> void:
	tempo_fase -= 1
	Global.tempo_fase = tempo_fase
	if tempo_fase == 0:
		go_to_morrer_state()
		tempo_fase_contador.stop()
