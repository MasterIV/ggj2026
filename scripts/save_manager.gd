extends Node

const SAVE_PATH := "user://savegame.cfg"

var data := {
	"best_score": 0,
	"last_score": 0
}

func save_data():
	var config := ConfigFile.new()
	for key in data:
		config.set_value("game", key, data[key])
	config.save(SAVE_PATH)
	
	# Flush to IndexedDB on web builds
	if OS.has_feature("web"):
		_sync_web_filesystem()

func load_data():
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		for key in data:
			data[key] = config.get_value("game", key, data[key])

func set_score(score: int):
	data["last_score"] = score
	if score > data["best_score"]:
		data["best_score"] = score
	save_data()

func get_best_score() -> int:
	return data["best_score"]

func get_last_score() -> int:
	return data["last_score"]

func _sync_web_filesystem():
	JavaScriptBridge.eval("""
		if (window.FS && window.FS.syncfs) {
			window.FS.syncfs(false, function(err) {
				if (err) console.warn('FS sync error:', err);
			});
		}
	""")
