extends AudioStreamPlayer

var music: AudioStreamInteractive = AudioStreamInteractive.new()

var clips = {
	RoomData.Regions.Starting: {
		RoomData.RoomStates.Default: 0,
		RoomData.RoomStates.Respite: 0,
		RoomData.RoomStates.Battle: 0,
		RoomData.RoomStates.Dialogue: 0,
		RoomData.RoomStates.Boss: 0,
		RoomData.RoomStates.Rescue: 0
	},
	RoomData.Regions.Factory: {
		RoomData.RoomStates.Default: 0,
		RoomData.RoomStates.Respite: 0,
		RoomData.RoomStates.Battle: 0,
		RoomData.RoomStates.Dialogue: 0,
		RoomData.RoomStates.Boss: 0,
		RoomData.RoomStates.Rescue: 0
	},
	RoomData.Regions.Jungle: {
		RoomData.RoomStates.Default: 0,
		RoomData.RoomStates.Respite: 0,
		RoomData.RoomStates.Battle: 0,
		RoomData.RoomStates.Dialogue: 0,
		RoomData.RoomStates.Boss: 0,
		RoomData.RoomStates.Rescue: 0
	},
	RoomData.Regions.Penultimate: {
		RoomData.RoomStates.Default: 0,
		RoomData.RoomStates.Respite: 0,
		RoomData.RoomStates.Battle: 0,
		RoomData.RoomStates.Dialogue: 0,
		RoomData.RoomStates.Boss: 0,
		RoomData.RoomStates.Rescue: 0
	},
	RoomData.Regions.Final: {
		RoomData.RoomStates.Default: 0,
		RoomData.RoomStates.Respite: 0,
		RoomData.RoomStates.Battle: 0,
		RoomData.RoomStates.Dialogue: 0,
		RoomData.RoomStates.Boss: 0,
		RoomData.RoomStates.Rescue: 0
	}
}

func _on_ready():
	WorldData.on_region_changed.connect(_on_region_changed)
	WorldData.on_room_state_changed.connect(_on_room_state_changed)
	self.set_stream(music)
	self.play()


func _on_region_changed(new_region: RoomData.Regions):
	pass

func _on_room_state_changed(new_room_state: RoomData.RoomStates):
	pass
