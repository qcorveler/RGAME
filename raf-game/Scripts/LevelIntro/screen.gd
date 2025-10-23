extends Control

var vis = false
var can_write = false

func toggle_visible() :
	can_write = false
	_cursor_visible = true
	_password = ""
	result_label.text = ""
	vis = !vis
	visible = vis
	GameState.dialogue_active = vis
	GameState.wait_player_input = vis
	GameState.game_pausable = !vis
	GameState.level_intro_screen_reached = true

@export var secret_char: String = "•"        # caractère affiché pour chaque lettre
@export var cursor_char: String = "_"        # underscore clignotant
@export var blink_interval: float = 0.5      # secondes pour clignoter
@export var max_length: int = 12             # longueur max mot de passe

var _password := ""          # la valeur réelle (non affichée)
var _cursor_visible := true
var _blink_timer := 0.0

@onready var textureRect := $TextureRect
@onready var password_label : Label = textureRect.get_node("Password")

@onready var result_label : Label = textureRect.get_node("Result")

func _ready():
	# style et texte initial
	password_label.text = _display_text()
	# optionnel : set focus pour capturer les touches
	set_process_unhandled_input(true)
	grab_focus()
	# config visuelle (monospace conseillé)
	# label.add_font_override("font", preload("res://fonts/YourPixelFont.tres"))

func _process(delta: float) -> void:
	# gestion du clignotement du curseur underscore
	_blink_timer += delta
	if _blink_timer >= blink_interval:
		can_write = true
		_blink_timer = 0.0
		_cursor_visible = !_cursor_visible
		password_label.text = _display_text()

func _unhandled_input(event):
	# ne traiter que les appuis clavier valides (pas d'echo)
	if event is InputEventKey and event.pressed and not event.echo:
		# Escape
		if event.keycode == Key.KEY_ESCAPE and vis:
			toggle_visible()
		# Backspace
		if event.keycode == Key.KEY_BACKSPACE:
			if _password.length() > 0:
				_password = _password.substr(0, _password.length() - 1)
				password_label.text = _display_text()
		# Enter -> valider le mot de passe
		elif event.keycode == Key.KEY_ENTER or event.keycode == Key.KEY_KP_ENTER:
			_on_submit()
		else :
			# event.unicode est l'Unicode du caractère tapé (0 si non imprimable)
			var code = event.unicode
			if code > 0:
				var ch = char(code)
				# on filtre les caractères non imprimables (optionnel)
				if _is_printable(ch) and _password.length() < max_length and can_write :
					_password += ch
					password_label.text = _display_text()

# Construit la chaîne affichée (masqué + curseur)
func _display_text() -> String:
	var masked = secret_char.repeat(_password.length())
	if _cursor_visible:
		return masked + cursor_char
	else:
		return masked + " "  # espace pour garder la largeur

# Optionnel : fonction de validation pour savoir si caractère imprimable
func _is_printable(ch: String) -> bool:
	if ch == "\n" or ch == "\r" or ch == "\t":
		return false
	return true

func _on_submit():
	# Ici : vérification du mot de passe
	var expected = "TaiTa"  # remplace par ta valeur
	if _password == expected or _password == "29TaiTa22" or _password == "22TaiTa29" :
		# appelle la fonction suivante : ex. unlock_level()
		_on_password_success()
	else:
		_on_password_fail()

func _on_password_success():
	# Effet visuel ou suite du jeu
	# Réinitialise le champ si besoin
	_password = ""
	password_label.text = _display_text()
	result_label.label_settings.font_color = Color("009000ff")
	result_label.text = "Mot de passe correct"
	# ... autre logique

func _on_password_fail():
	# par ex. clear, vibrate, jouer son d'erreur
	_password = ""
	password_label.text = _display_text()
	result_label.label_settings.font_color = Color("900000ff")
	result_label.text = "Mot de passe incorrect"
	# tu peux aussi jouer une animation d'erreur
