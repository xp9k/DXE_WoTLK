local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- MOORABI
---------------------------------

do
local data = {
	version = 1,
	key = "Moorabi",
	zone = L.zone["Gundrak"],
	category = L.zone["Gundrak"],
	name = L.npc_wotlk_party["Moorabi"],
	triggers = {
		scan = 29305, -- Moorabi
		yell = L.chat_wotlk_party[""],
		},
	onactivate = {
		tracing = {29305},
		tracerstart = true,
		tracerstop = true,
		combatstop = true,
		defeat = 29305,
		},
	alerts = {
		transformwarn = {
			varname = format(L.alert["%s Warning"], SN[55098]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[55098]),
			sound = "ALERT1",
			icon = ST[55098],
			counter = true,
			},
		transformcd = {
			varname = format(L.alert["%s Cooldown"], SN[55098]),
			type = "dropdown",
			text = format(L.alert["%s Cooldown"], SN[55098]),
			time = 10,
			sound = "ALERT1",
			color1 = "BROWN",
			icon = ST[55098],
			},
		},
	events = {
		-- Transform,
		{
			type = "combatevent",
			eventtype = "SPELL_CAST_START",
			spellname = 55098, --Transform
			execute = {
				{
					"alert", "transformwarn",
					"alert", "transformcd",
					},
				},
			},
		},
	}
DXE:RegisterEncounter(data)
end
