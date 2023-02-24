local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- VOLKHAN
---------------------------------

do
local data = {
	version = 1,
	key = "Volkhan",
	zone = L.zone["Halls of Lightning"],
	category = L.zone["Halls of Lightning"],
	name = L.npc_wotlk_party["Volkhan"],
	triggers = {
		scan = 28587, -- Volkhan
		yell = L.chat_wotlk_party[""],
	},
	onactivate = {
		tracing = {28587},
		tracerstart = true,
		tracerstop = true,
		combatstop = true,
		defeat = 28587,
	},
	alerts = {
		stompwarn = {
			varname = format(L.alert["%s Warning"], SN[59529]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[59529]),
			time = 3,
			sound = "ALERT1",
			icon = ST[59529],
		},
		stompcd = {
			varname = format(L.alert["%s Cooldown"], SN[59529]),
			type = "dropdown",
			text = format(L.alert["%s Cooldown"], SN[59529]),
			time = 30,
			color1 = "BLUE",
			icon = ST[59529],
		},
	},
	events = {
		-- Stomp,
		{
			type = "combatevent",
			eventtype = "SPELL_CAST_START",
			spellname = 59529, --Stomp
			execute = {
				{
					"alert", "stompwarn",
					"alert", "stompcd",
				},
			},
		},
	},
}
DXE:RegisterEncounter(data)
end
