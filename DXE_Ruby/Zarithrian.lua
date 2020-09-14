local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Zarithrian
---------------------------------

do
	local data = {
		version = 5,
		key = "Zarithrian",
		zone = L.zone["The Ruby Sanctum"],
		category = L.zone["Ruby"],
		name = L.npc_ruby["Zarithrian"],
		triggers = {
			scan = {39746} -- Zarithrian
		},
		onactivate = {
			tracing = {39746}, -- Zarithrian
			tracerstart = true,
			tracerstop = true,
			combatstop = true,
			defeat = 39746,
		},
		onstart = {
			"alert", {"intimidatingroarcd", time = 14},
		},
		alerts = {
			intimidatingroardur = {
				varname = format(L.alert["%s Duration"],SN[74384]),
				type = "centerpopup",
				text = format("%s: &dstname_or_YOU&",SN[74384]),
				time = 4,
				flashtime = 4,
				color1 = "INDIGO",
				icon = ST[74384],
				flashscreen = true,
			},
			intimidatingroarcd = {
				varname = format(L.alert["%s Cooldown"],SN[74384]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[74384]),
				time = 33,
				flashtime = 5,
				color1 = "PURPLE",
				icon = ST[74384],
				audiocd = 5,
			},
			summonaddscd = {
				varname = format(L.alert["%s Cooldown"],SN[74384]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[74384]),
				time = 33,
				flashtime = 5,
				color1 = "PURPLE",
				icon = ST[74384],
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
				spellid = 74384,
				execute = {
					{
						"alert", "intimidatingroardur",
						"alert", "intimidatingroarcd",
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


