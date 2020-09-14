local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Tyrannus
---------------------------------

do
	local data = {
		version = 1,
		key = "Tyrannus",
		zone = L.zone["Pit of Saron"],
		category = L.zone["WoTLK Party"],
		name = L.npc_wotlk_party["Tyrannus"],
		triggers = {
			scan = 36658, -- Tyrannus
		},
		onactivate = {
			tracing = {36658}, -- Tyrannus
			tracerstart = true,
			tracerstop = true,
			combatstop = true,
			defeat = 36658,
		},
		userdata = {
			corruptsoultext = "",
		},
		onstart = {
			"alert", "corruptsoulcd",
		},
		alerts = {
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
			markofrimefangother = {
				varname = format(L.alert["%s on others"],SN[69275]),
				text = format("%s: #5#!",SN[69275]),
				type = "centerpopup",
				time = 7,
				flashtime = 4,
				sound = "ALERT4",
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
			overlordsbrandother = {
				varname = format(L.alert["%s on others"],SN[69172]),
				text = format("%s: #5#!",SN[69172]),
				type = "centerpopup",
				time = 8,
				flashtime = 4,
				color1 = "MAGENTA",
				icon = ST[69172],
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
			-- Corrupt Soul
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
						"alert", "markofrimefangself",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert", "markofrimefangother",						
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
						"announce", "markofrimefangsay",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert", "overlordsbrandother",						
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


