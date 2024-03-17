extends Node

const level_scores_collection = "level_scores"
const users_collection = "users"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Save user to firestore
func save_user(username, username_with_uuid):
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(users_collection)
	var add_task : FirestoreTask = firestore_collection.add(
		username_with_uuid + '_' + Globals.firebase_server_id, 
		{
			'username': username,
			'username_uuid': username_with_uuid,
			'server_id': Globals.firebase_server_id,
			'registration_time': OS.get_ticks_msec()
		}
	)
	return add_task


# Save user to firestore
func save_user_level_highscore(username, level, difficulty, highscore):
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(level_scores_collection)
	var update_task : FirestoreTask = firestore_collection.update(
		username + '_' + String(level) + '_' + String(difficulty) + '_' + Globals.firebase_server_id, 
		{
			'username_uuid': username,
			'username': Globals.get_username_plain(),
			'server_id': Globals.firebase_server_id,
			'level': level,
			'difficulty': difficulty,
			'score': highscore,
			'time': OS.get_ticks_msec()
		}
	)
	return update_task
