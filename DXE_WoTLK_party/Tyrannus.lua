local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Tyrannus
---------------------------------

do
	local data = {
		version = 1,
		key = "Tyrannus",
		zone = L.zone["Pit of Saron"],
		category = L.zone["Pit of Saron"],
		name = L.npc_wotlk_party["Tyrannus"],
		triggers = {
			scan = 36658, -- Tyrannus
			yell = L.chat_wotlk_party["^Alas, brave, brave adventurers"],
		},
		onactivate = {
			tracing = {36658}, -- Tyrannus
			tracerstart = true,
			-- tracerstop = true,
			-- combatstop = true,
			defeat = 36658,
		},
		userdata = {
			phase = "0",
		},
		onstart = {
			{
				"expect",{"#1#","find",L.chat_wotlk_party["^Alas, brave, brave adventurers"]},
				"alert","zerotoonecd",
			}
		},
		alerts = {
			zerotoonecd = {
				varname = format(L.alert["%s Timer"],L.alert["Phase One"]),
				type = "centerpopup",
				text = format(L.alert["%s Begins"],L.alert["Phase One"]),
				time = 31,
				flashtime = 10,
				color1 = "MIDGREY",
				icon = ST[3648],
			},
			markofrimefangself = {
				varname = format(L.alert["%s on self"],SN[69275]),
				text = format("%s: %s!",SN[69275],L.alert["YOU"]),
				type = "centerpopup",
				time = 7,
				flashtime = 4,
				sound = "ALERT3",
				color1 = "BLUE",
				color2 = "YELLOW",
				icon = ST[69275],
				flashscreen = true,
			},
			markofrimefangdur = {
				varname = format(L.alert["%s Duration"],SN[69275]),
				text = format("%s: #5#!",SN[69275]),
				type = "centerpopup",
				time = 7,
				flashtime = 4,
				sound = "ALERT4",
				color1 = "BLUE",
				icon = ST[69275],
			},
			markofrimefangwarn = {
				varname = format(L.alert["%s Warning"],SN[69275]),
				text = format("%s: #5#!",SN[69275]),
				type = "simple",
				time = 5,
				flashtime = 5,
				color1 = "BLUE",
				icon = ST[69275],
			},
			overlordsbrandself = {
				varname = format(L.alert["%s on self"],SN[69172]),
				text = format("%s: %s!",SN[69172],L.alert["YOU"]),
				type = "centerpopup",
				time = 8,
				flashtime = 4,
				sound = "ALERT2",
				color1 = "MAGENTA",
				color2 = "YELLOW",
				icon = ST[69172],
				flashscreen = true,
			},
			overlordsbranddur = {
				varname = format(L.alert["%s Duration"],SN[69172]),
				text = format("%s: #5#!",SN[69172]),
				type = "centerpopup",
				time = 8,
				flashtime = 4,
				color1 = "MAGENTA",
				icon = ST[69172],
			},
			unholypowerdur = {
				varname = format(L.alert["%s Duration"],SN[69629]),
				text = format("%s: #2#!",SN[69629]),
				type = "centerpopup",
				time = 10,
				flashtime = 10,
				sound = "ALERT5",
				color1 = "INDIGO",
				icon = ST[69629],
			},
		},
		raidicons = {
				markofrimefangmark = {
				varname = SN[69275],
				type = "FRIENDLY",
				persist = 5,
				unit = "&upvalue&",
				icon = 1,
			},
		},
		announces = {
			markofrimefangsay = {
				varname = format(L.alert["Say %s on self"],SN[69275]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[69275]).."!",
			},
		},
		events = {
			-- Метка Инея
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 69275,
				execute = {
					{
						"raidicon","markofrimefangmark",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"announce", "markofrimefangsay",
					},
					{
						"alert", "markofrimefangdur",						
						"alert", "markofrimefangwarn",						
					},
				},
			},
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellid = 69275,
				execute = {
					{
						"removeraidicon","markofrimefangmark",
					},
				},
			},
			--	Overlord's Brand
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 69172,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert", "overlordsbrandself",				
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert", "overlordsbranddur",						
					},
				},
			},
			--	Unholy Power / Нечистая сила
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 69629,
				execute = {
					{
						"alert", "unholypowerdur",						
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


