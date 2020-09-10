local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- FESTERGUT
---------------------------------

do
	local data = {
		version = 14,
		key = "festergut",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Festergut"],
		triggers = {
			scan = {36626}, -- Festergut
		},
		onactivate = {
			tracerstart = true,
			combatstop = true,
			tracing = {36626}, -- Festergut
			defeat = 36626,
		},
		userdata = {
			inhaletime = {29, 33.5, loop = false, type = "series"},
			sporetime = {21,40,40,51, loop = false, type = "series"},
			sporeunits = {type = "container", wipein = 2},
			pungenttime = {133, 138, loop = false, type = "series"},
			gastrictext = "",
		},
		onstart = {
			{
				"alert","gassporecd",
				"alert","inhaleblightcd",
				"alert","pungentblightcd",
				"alert","enragecd",
				"set",{sporetime = {40,40,40,51,loop = true, type = "series"}},
				"set",{inhaletime = {33.5,33.5,33.5,68, loop = true, type = "series"}},
			},
		},
		alerts = {
			enragecd = {
				varname = L.alert["Enrage"],
				type = "dropdown",
				text = L.alert["Enrage"],
				time = 300,
				flashtime = 10,
				color1 = "RED",
				icon = ST[12317],
			},
			inhaleblightcd = {
				varname = format(L.alert["%s Cooldown"],SN[69165]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69165]),
				time = "<inhaletime>",
				color1 = "GREY",
				flashtime = 10,
				icon = ST[69165],
			},
			inhaleblightwarn = {
				varname = format(L.alert["%s Casting"],SN[69165]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[69165]),
				time = 3.5,
				flashtime = 3.5,
				color1 = "BROWN",
				sound = "ALERT1",
				icon = ST[69165],
			},
			gassporecd = {
				varname = format(L.alert["%s Cooldown"],SN[71221]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71221]),
				time = "<sporetime>",
				color1 = "YELLOW",
				flashtime = 5,
				icon = ST[71221],
			},
			gassporedur = {
				varname = format(L.alert["%s Duration"],SN[71221]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"],SN[71221]),
				time = 12,
				flashtime = 12,
				color1 = "MAGENTA",
				sound = "ALERT2",
				flashscreen = true,
				icon = ST[71221],
			},
			gassporeself = {
				varname = format(L.alert["%s on self"],SN[71221]),
				type = "simple",
				text = format("%s: %s!",SN[71221],L.alert["YOU"]).."!",
				time = 3,
				icon = ST[71221],
				throttle = 10,
			},
			vilegascd = {
				varname = format(L.alert["%s Cooldown"],SN[71218]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71218]),
				time = 20,
				flashtime = 5,
				color1 = "ORANGE",
				icon = ST[71288],
				throttle = 2,
			},
			vilegaswarn = {
				varname = format(L.alert["%s Warning"],SN[71218]),
				type = "simple",
				text = format(L.alert["%s Cast"],SN[71218]).."!",
				time = 3,
				color1 = "GREEN",
				sound = "ALERT3",
				icon = ST[71288],
				throttle = 2,
			},
			pungentblightwarn ={
				varname = format(L.alert["%s Casting"],SN[71219]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[71219]),
				time = 3,
				flashtime = 3,
				color1 = "PURPLE",
				sound = "ALERT5",
				flashscreen = true,
				icon = ST[71219],
			},
			pungentblightcd = {
				varname = format(L.alert["%s Cooldown"],SN[71219]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71219]),
				time = "<pungenttime>",
				color1 = "DCYAN",
				flashtime = 10,
				icon = ST[71219],
			},
			gastricbloatwarn = {
				varname = format(L.alert["%s Warning"],SN[72551]),
				type = "simple",
				text = "<gastrictext>",
				time = 3,
				color1 = "GOLD",
				icon = ST[72551],
			},
			malleablegoowarn = {
				varname = format(L.alert["%s Warning"],SN[72615]),
				type = "simple",
				text = format(L.alert["%s Cast"],SN[72615]),
				time = 3,
				sound = "ALERT6",
				color1 = "BLACK",
				icon = ST[72615],
				flashscreen = true,
				throttle = 2,
			},
		},
		windows = {
			proxwindow = true,
		},
		timers = {
			firegassporearrow = {
				{
					"expect",{"&playerdebuff|"..SN[71221].."&","==","false"},
					"arrow","gassporearrow",
				},
			},
		},
		arrows = {
			gassporearrow = {
				varname = format(L.alert["Closest %s"],SN[71221]),
				unit = "&closest|sporeunits&",
				persist = 12,
				action = "TOWARD",
				msg = L.alert["MOVE TOWARD"],
				spell = format(L.alert["Closest %s"],SN[71221]),
			},
		},
		raidicons = {
			vilegasmark = {
				varname = SN[71307],
				type = "MULTIFRIENDLY",
				persist = 6,
				reset = 3,
				unit = "#5#",
				icon = 1,
				total = 5,
			},
			gassporemark = {
				varname = SN[69278],
				type = "MULTIFRIENDLY",
				persist = 12,
				reset = 5,
				unit = "#5#",
				icon = 6,
				total = 3,
			},
		},
		events = {
			-- Inhale Blight
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69165,
				execute = {
					{
						"alert","inhaleblightcd",
						"alert","inhaleblightwarn",
					},
				},
			},
			-- Gas Spore
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 71221,
				execute = {
					{
						"quash","gassporecd",
						"alert","gassporedur",
						"alert","gassporecd",
						"scheduletimer",{"firegassporearrow",0.5},
					},
				},
			},
			-- Gas Spore
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69279,
				execute = {
					{
						"raidicon","gassporemark",
						"insert",{"sporeunits","#5#"},
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","gassporeself",
					},
				},
			},
			-- Vile Gas
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 69240,
				execute = {
					{
						"quash","vilegascd",
						"alert","vilegascd",
						"alert","vilegaswarn",
					},
				},
			},
			-- Vile Gas applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71218,
				execute = {
					{
						"raidicon","vilegasmark",
					},
				},
			},
			-- Pungent Blight
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 71219,
				execute = {
					{
						"alert","pungentblightcd",
						"alert","pungentblightwarn",
					},
				},
			},
			-- Gastric Bloat
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72551,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{gastrictext = format("%s: %s!",SN[72551],L.alert["YOU"])},
						"alert","gastricbloatwarn",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"set",{gastrictext = format("%s: #5#!",SN[72551])},
						"alert","gastricbloatwarn",
					},
				},
			},
			-- Gastric Bloat applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 72551,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{gastrictext = format("%s: %s! %s!",SN[72551],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"alert","gastricbloatwarn",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"set",{gastrictext = format("%s: #5#! %s!",SN[72551],format(L.alert["%s Stacks"],"#11#")) },
						"alert","gastricbloatwarn",
					},
				},
			},
			-- Malleable Goo Summon Trigger
			{
				type = "event",
				event = "UNIT_SPELLCAST_SUCCEEDED",
				execute = {
					{
						"expect",{"#2#","==",SN[72310]},
						"alert","malleablegoowarn",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end