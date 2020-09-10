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
			yell = L.chat_wotlk_party["^Finally"],
			scan = {
				36497, 36498, -- Bronjahm
			},
		},
		onactivate = {
			tracing = {36497}, -- Bronjahm
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
				text = format("%s: %s!",SN[68839],L.alert["YOU"]),
				type = "centerpopup",
				time = 4,
				flashtime = 4,
				sound = "ALERT4",
				color1 = "MAGENTA",
				icon = ST[68839],
				flashscreen = true,
			},
			corruptsoulcd = {
				varname = format(L.alert["%s Cooldown"],SN[68839]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[68839]),
				time = 40,
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
				eventtype = "SPELL_CAST_START",
				spellid = 68839,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert", "corruptsoulcd",
						"alert", "corruptsoulself",
						"raidicon","corruptsoulmark",
						"announce", "corruptsoulsay",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert", "corruptsoulother",
						"alert", "corruptsoulcd",
						"raidicon","corruptsoulmark",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


