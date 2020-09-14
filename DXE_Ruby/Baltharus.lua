local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Baltharus
---------------------------------

do
	local data = {
		version = 5,
		key = "Baltharus",
		zone = L.zone["The Ruby Sanctum"],
		category = L.zone["Ruby"],
		name = L.npc_ruby["Baltharus"],
		triggers = {
			scan = {39751} -- Baltharus
		},
		onactivate = {
			tracing = {39751}, -- Baltharus
			tracerstart = true,
			tracerstop = true,
			combatstop = true,
			defeat = 39751,
		},
		onstart = {
			"alert", "bladetempestcd",
		},
		alerts = {
			bladetempestdur = {
				varname = format(L.alert["%s Duration"],SN[75125]),
				type = "centerpopup",
				text = format("%s: &dstname_or_YOU&",SN[75125]),
				time = 4,
				flashtime = 4,
				sound = "ALERT1",
				color1 = "RED",
				color2 = "INDIGO",
				icon = ST[75125],
				flashscreen = true,
			},
			bladetempestcd = {
				varname = format(L.alert["%s Cooldown"],SN[75125]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[75125]),
				time = 17,
				flashtime = 5,
				color1 = "BLUE",
				icon = ST[75125],
				audiocd = 5,
			},
		},
		windows = {
			proxwindow = true,
			proxrange = 12,
		},
		events = {
			-- Blade Tempest
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 75125,
				execute = {
					{
						"alert", "bladetempestdur",
						"alert", "bladetempestcd",
					},
				},
			},
			-- Summon copy
			{
				type = "event",
				event = "YELL",
				execute = {
					{
						"expect",{"#1#","find",L.chat_ruby["^Twice the pain and half the fun"]},
						"quash","bladetempestcd",
						"alert", "bladetempestcd",
					},
				}
			},
		},
	}

	DXE:RegisterEncounter(data)
end


