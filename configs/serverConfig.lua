Auth = exports.plouffe_lib:Get("Auth")
Callback = exports.plouffe_lib:Get("Callback")

Server = {
	CurrentInventoryCoords = {},
	CurrentRoomId = {},
	CurrentHotelRooms = {
		{amount = 0},
		{amount = 0},
		{amount = 0}
	}
}

Hotel = {}
HotelFnc = {} 

Hotel.Player = {}

Hotel.Props = {}

Hotel.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0),
	isInHotel = false,
	isRaiding = false
}

Hotel.Coords = {
	entry = {
		name = "entry",
		coords = vector3(-270.85577392578, -957.96130371094, 31.227434158325),
		maxDst = 1.0,
		protectEvents = true,
		isKey = true,
		isZone = true,
		nuiLabel = "Chambre d'hotel",
		keyMap = {
			checkCoordsBeforeTrigger = true,
			onRelease = true,
			releaseEvent = "plouffe_hotels:enterroom",
			key = "E"
		}
	},

	hotel_raid_entry = {
		groups = {police = {["7"] = true}},
		name = "hotel_raid_entry",
		coords = vector3(-270.85577392578, -957.96130371094, 31.227434158325),
		maxDst = 1.0,
		protectEvents = true,
		isKey = true,
		isZone = true,
		nuiLabel = "Raid une chambre d'hotel",
		keyMap = {
			checkCoordsBeforeTrigger = true,
			onRelease = true,
			releaseEvent = "plouffe_hotels:enterroom_raid",
			key = "K"
		}
	}
}

Hotel.Room = {
	entry = vector3(-270.44836425781, -957.59515380859, 31.227426528931),
	coords = {
		{
			coords = vector3(-289.81155395508, -961.70782470703, 10.8403816223145)
		},

		{
			coords = vector3(-270.09567260742, -945.45391845703, 10.660400390625)
		},

		{
			coords = vector3(-248.55471801758, -954.26641845703, 10.72038269043)
		},
	},
	heading = 36.02350997924805,
	model = GetHashKey("furnitured_lowapart"),
	offSets = {
		exit = vector3(5.0,-1.38,0.3456),
		inventory = vector3(-2.92,4.20,0.3456),
		wardrobe = vector3(1.22,-2.64,0.3456)
	},
	zone = {
		exit = {
			name = "hotelExit",
			coords = vector3(0,0,0),
			maxDst = 1.0,
			protectEvents = true,
			isKey = true,
			isZone = true,
			nuiLabel = "Sortir",
			aditionalParams = {action = "exit"},
			keyMap = {
				checkCoordsBeforeTrigger = true,
				onRelease = true,
				releaseEvent = "plouffe_hotels:hotelaction",
				key = "E"
			}
		},

		inventory = {
			name = "hotelInventory",
			coords = vector3(0,0,0),
			maxDst = 1.0,
			protectEvents = true,
			isKey = true,
			isZone = true,
			nuiLabel = "Inventaire",
			aditionalParams = {action = "inventory"},
			keyMap = {
				checkCoordsBeforeTrigger = true,
				onRelease = true,
				releaseEvent = "plouffe_hotels:hotelaction",
				key = "E"
			}
		},

		wardrobe = {
			name = "hotelWardrobe",
			coords = vector3(0,0,0),
			maxDst = 1.0,
			protectEvents = true,
			isKey = true,
			isZone = true,
			nuiLabel = "Garde robe",
			aditionalParams = {action = "wardrobe"},
			keyMap = {
				checkCoordsBeforeTrigger = true,
				onRelease = true,
				releaseEvent = "plouffe_hotels:hotelaction",
				key = "E"
			}
		},
	}
}
