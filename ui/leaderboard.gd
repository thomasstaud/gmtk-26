extends Control

@onready var time: Label = %Time
@onready var name_edit: LineEdit = %Name
@onready var error: Label = %Error
@onready var submit: Button = %Submit

@onready var scores_container: VBoxContainer = %ScoresContainer
@onready var message_container: CenterContainer = %MessageContainer
@onready var text_message: Label = %TextMessage

const SCORE_ITEM = preload("uid://bx85ahfgnoqyy")

var list_index = 0
var ld_name = "main"
var options := Talo.leaderboards.GetEntriesOptions.new()

func _ready():
	time.text = UI.format_ms(GameManager.final_time())
	
	options.page = 0
	
	add_loading_scores_message()
	var res := await Talo.leaderboards.get_entries(ld_name, options)
	var scores: Array[TaloLeaderboardEntry] = res.entries
	hide_message()
	render_board(scores)


func refresh() -> void:
	list_index = 0
	var entries = scores_container.get_children()
	for entry in entries:
		scores_container.remove_child(entry)
	
	await get_tree().create_timer(0.1, true, true, true).timeout
	add_loading_scores_message()
	var res := await Talo.leaderboards.get_entries(ld_name, options)
	var scores: Array[TaloLeaderboardEntry] = res.entries
	hide_message()
	render_board(scores)

func render_board(scores: Array[TaloLeaderboardEntry]) -> void:
	if scores.is_empty():
		add_no_scores_message()
	else:
		if len(scores) > 1 and scores[0].score > scores[-1].score:
			scores.reverse()
		for i in range(len(scores)):
			var score = scores[i]
			add_item(score.player_alias.display_name, UI.format_ms(score.score))

func reverse_order(scores: Array) -> Array:
	if len(scores) > 1 and scores[0].score > scores[-1].score:
		scores.reverse()
	return scores


func sort_by_score(a: Dictionary, b: Dictionary) -> bool:
	if a.score > b.score:
		return true;
	else:
		if a.score < b.score:
			return false;
		else:
			return true;


func add_item(player_name: String, score_value: String) -> void:
	var item = SCORE_ITEM.instantiate()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.offset_top = list_index * 100
	scores_container.add_child(item)

func add_no_scores_message():
	var item = text_message
	item.text = "No scores yet!"
	message_container.show()
	item.offset_top = 135


func add_loading_scores_message() -> void:
	var item = text_message
	item.text = "Loading scores..."
	message_container.show()
	item.offset_top = 135

func hide_message() -> void:
	message_container.hide()


func _on_menu_pressed() -> void:
	GameManager.to_level_select()


func _on_submit_pressed() -> void:
	var score = GameManager.final_time()
	if GameManager.total_submission == score:
		return
	
	var player_name = name_edit.text
	if player_name != "":
		error.hide()
		await Talo.players.identify("username", player_name)
		Talo.leaderboards.add_entry(ld_name, score)
		GameManager.total_submission = score
		submit.disabled = true
		refresh()
	else:
		error.show()
