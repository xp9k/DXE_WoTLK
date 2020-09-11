local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Bronjahm
---------------------------------

do
	local data = {
		version = 1,
		key = "Bronjahm",
		zone = L.zone["The Forge of Souls"],
		category = L.zone["WoTLK Party"],
		name = L.npc_wotlk_party["Bronjahm"],
		triggers = {
			scan = {36497} -- Bronjahm
		},
		onactivate = {
			tracing = {36497}, -- Bronjahm
			tracerstart = true,
			tracerstop = true,
			combatstop = true,
			defeat = 36497,
		},
		onstart = {
			"alert","corruptsoulcd",
		},
		alerts = {
			corruptsoulself = {
				varname = format(L.alert["%s on self"],SN[68839]),
				text = format("%s: %s!",SN[68839],L.alert["YOU"]),
				type = "centerpopup",
				time = 4,
				flashtime = 4,
				sound = "ALERT3",
				color1 = "MAGENTA",
				color2 = "YELLOW",
				icon = ST[68839],
				flashscreen = true,
			},
			corruptsoulother = {
				varname = format(L.alert["%s on others"],SN[68839]),
				text = format("%s: %s! %s!",SN[68839],L.alert["YOU"],L.alert["MOVE AWAY"]),
				type = "centerpopup",
				time = 4,
				flashtime = 4,
				sound = "ALERT4",
				color1 = "MAGENTA",
				icon = ST[68839],
				flashscreen = false,
			},
			corruptsoulcd = {
				varname = format(L.alert["%s Cooldown"],SN[68839]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[68839]),
				time = 30,
				flashtime = 10,
				color1 = "PURPLE",
				icon = ST[68839],
			},
		},
		raidicons = {
				corruptsoulmark = {
				varname = SN[68839],
				type = "FRIENDLY",
				persist = 5,
				unit = "&upvalue&",
				icon = 1,
			},
		},
		announces = {
			corruptsoulsay = {
				varname = format(L.alert["Say %s on self"],SN[68839]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[68839]).."!",
			},
		},
		events = {
			-- Corrupt Soul
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 68839,
				execute = {
					{
						"raidicon","corruptsoulmark",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert", "corruptsoulself",						
						"announce", "corruptsoulsay",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert", "corruptsoulother",
					},
				},
			},
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellid = 68839,
				execute = {
					{
						"removeraidicon","corruptsoulmark",
					},
					{
						"alert", "corruptsoulcd",
					},
				},
			},
			-- Soulstorm
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellid = 68872,
				execute = {
					{
						"quash", "corruptsoulcd",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


