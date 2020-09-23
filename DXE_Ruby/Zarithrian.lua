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
--			tracerstop = true,
			combatstop = true,
			defeat = 39746,
		},
		onstart = {
			"alert", {"intimidatingroarcd", time = 14},
			"alert", {"summonaddscd", time = 16},
		},
		alerts = {
			intimidatingroardur = {
				varname = format(L.alert["%s Duration"],SN[74384]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"],SN[74384]),
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
				time = 38,
				flashtime = 5,
				color1 = "PURPLE",
				icon = ST[74384],
				audiocd = 5,
			},
			summonaddscd = {
				varname = format(L.alert["%s Cooldown"],SN[74398]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[74398]),
				time = 45,
				flashtime = 5,
				color1 = "CYAN",
				icon = ST[74398],
			},
		},
		events = {
			-- Устрашающий рев
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 74384,
				execute = {
					{
						"quash", "intimidatingroardur",
						"alert", "intimidatingroardur",
						"quash", "intimidatingroarcd",
						"alert", "intimidatingroarcd",
						"quash", "summonaddscd",
						"alert", "summonaddscd",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


