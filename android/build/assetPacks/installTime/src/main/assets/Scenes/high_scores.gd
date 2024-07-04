class_name HighScores extends Resource

@export var scores: Array[int]
@export var names: Array[String]

const SAVE_PATH:String = "user://high_scores.tres"

func _init():
	scores.resize(10)
	names.resize(10)
	for i in range(10):
		scores[i] = 0
		names[i] = ""

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)

static func load_or_create() -> HighScores:
	var res:HighScores
	if FileAccess.file_exists(SAVE_PATH):
		res = ResourceLoader.load(SAVE_PATH) as HighScores
		if res == null:
			res = HighScores.new()
	else:
		res = HighScores.new()
	return res

func update_top_scores(new_score):
	var insert_index = -1
	for i in range(10):
		if new_score > scores[i]:
			insert_index = i
			break
			
	return insert_index

func insert_new_score(insert_index, new_score, name):	
	scores.pop_back()
	scores.insert(insert_index, new_score)
	names.pop_back()
	names.insert(insert_index, name)
