local L,SN,ST = DXE.L,DXE.SN,DXE.ST


---------------------------------
-- DEATHWHISPER
---------------------------------

do
	local data = {
		version = 33,
		key = "deathwhisper",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Deathwhisper"],
		triggers = {
			scan = {
				36855, -- Lady Deathwhisper
			},
			yell = L.chat_citadel["^What is this disturbance"],
		},
		userdata = {
			culttime = {7,60,loop = false, type = "series"},
			insignificancetext = "",
			dominatetext = format("%s: #5#!",SN[71289]),
			dominatetime = {31,40.4,loop = false,type = "series"},
		},
		onstart = {
			{
				"expect",{"&difficulty&",">=","3"},
				"set",{culttime = {7,45,loop = false, type = "series"}},
			},
			{
				"alert","cultcd",
				"alert","enragecd",
				"scheduletimer",{"firecult",7},
			},
			{
				"expect",{"&difficulty&",">","1"},
				"alert","dominatecd",
			},
		},
		timers = {
			firecult = {
				{
					"alert","cultcd",
					"scheduletimer",{"firecult","<culttime>"},
				},
			},
		},
		onactivate = {
			combatstop = true,
			tracing = {36855,powers={true}}, -- Lady Deathwhisper
			defeat = 36855, -- Lady Deathwhisper
		},
		alerts = {
			enragecd = {
				varname = L.alert["Enrage"],
				type = "dropdown",
				text = L.alert["Enrage"],
				time = 600,
				flashtime = 10,
				color1 = "RED",
				icon = ST[12317],
			},
			dndself = {
				varname = format(L.alert["%s on self"],SN[71001]),
				text = format("%s: %s!",SN[71001],L.alert["YOU"]),
				type = "simple",
				time = 3,
				sound = "ALERT1",
				color1 = "GREEN",
				icon = ST[71001],
				flashscreen = true,
			},
			martyrdomwarn = {
				varname = format(L.alert["%s Casting"],SN[72500]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[72500]),
				time = 4,
				color1 = "WHITE",
				sound = "ALERT9",
				icon = ST[72500],
			},
			cultcd = {
				varname = format(L.alert["%s Spawns"],L.alert["Cult"]),
				text = format(L.alert["%s Spawns"],L.alert["Cult"]),
				type = "dropdown",
				time = "<culttime>",
				flashtime = 10,
--				sound = "ALERT2",
				color1 = "BROWN",
				icon = ST[61131],
			},
			manabarrierwarn = {
				varname = format(L.alert["%s Removal"],SN[70842]),
				text = format(L.alert["%s Removed"],SN[70842]).."!",
				type = "simple",
				time = 3,
--				sound = "ALERT3",
				color1 = "TEAL",
				icon = ST[70842],
			},
			summonspiritwarn = {
				varname = format(L.alert["%s Warning"],SN[71426]),
				text = SN[71426].."! "..L.alert["CAREFUL"].."!",
				type = "simple",
				time = 5,
				sound = "ALERT2",
				color1 = "BLACK",
				icon = ST[71426],
				throttle = 3,
			},
			insignificancewarn = {
				varname = format(L.alert["%s Warning"],SN[71204]),
				text = "<insignificancetext>",
				type = "simple",
				time = 3,
--				sound = "ALERT4",
				color1 = "TAN",
				icon = ST[71204],
			},
			torporself = {
				varname = format(L.alert["%s on self"],SN[71237]),
				text = format("%s: %s!",SN[71237],L.alert["YOU"]),
				type = "simple",
				time = 3,
				color1 = "PURPLE",
--				sound = "ALERT5",
				icon = ST[71237],
			},
			torporwarn = {
				varname = format(L.alert["%s on others"],SN[71237]),
				text = format("%s: #5#!",SN[71237]),
				type = "simple",
				time = 3,
				color1 = "PURPLE",
--				sound = "ALERT5",
				icon = ST[71237],
			},
			dominatewarn = {
				varname = format(L.alert["%s Warning"],SN[71289]),
				text = format("%s: &debuffednames|"..SN[71289].."&", SN[71289]),
				type = "simple",
				time = 3,
				color1 = "GREY",
--				sound = "ALERT6",
				icon = ST[71289],
				throttle = 3,
			},
			dominatecd = {
				varname = format(L.alert["%s Cooldown"],SN[71289]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71289]),
				time = "<dominatetime>",
				flashtime = 10,
				audiocd = 5,
				color1 = "INDIGO",
				icon = ST[71289],
				throttle = 3,
			},
			frostboltwarn = {
				varname = format(L.alert["%s Casting"],SN[72007]),
				text = format(L.alert["%s Casting"],SN[72007]),
				type = "centerpopup",
				time = 2,
				color1 = "BLUE",
				sound = "ALERT4",
				icon = ST[72007],
			},
		},
		raidicons = {
			dominatemark = {
				varname = SN[71289],
				type = "MULTIFRIENDLY",
				persist = 10,
				reset = 5,
				unit = "#5#",
				icon = 1,
				total = 3,
			},
		},
		events = {
			-- Dark Martyrdom
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72500,
				execute = {
					{
						"alert","martyrdomwarn",
					},
				},
			},
			-- Summon Spirit
			{
				type = "combatevent",
				eventtype = "SPELL_SUMMON",
				spellname = 71426,
				execute = {
					{
						"alert","summonspiritwarn",
					},
				},
			},
			-- Death and Decay self
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71001,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","dndself",
					},
				},
			},
			-- Mana Barrier
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 70842,
				srcnpcid = 36855, -- Deathwhisper
				execute = {
					{
						"alert","manabarrierwarn",
					},
					{
						"expect",{"&difficulty&","<=","2"},
						"quash","cultcd",
						"canceltimer","firecult",
					},
					{
						
						"expect",{"&difficulty&",">=","3"},
						"quash","cultcd",
						"set",{culttime = 45},
						"alert","cultcd",
					},
				},
			},
			-- Touch of Insignificance
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71204,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{insignificancetext = format("%s: %s!",L.alert["Touch"],L.alert["YOU"])},
						"alert","insignificancewarn",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"set",{insignificancetext = format("%s: #5#!",L.alert["Touch"])},
						"alert","insignificancewarn",
					},
				},
			},
			-- Touch of Insignificance stacks
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 71204,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{insignificancetext = format("%s: %s! %s!",L.alert["Touch"],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"alert","insignificancewarn",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"set",{insignificancetext = format("%s: #5#! %s!",L.alert["Touch"],format(L.alert["%s Stacks"],"#11#"))},
						"alert","insignificancewarn",
					},
				},
			},
			-- Curse of Torpor
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71237,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","torporself",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert","torporwarn",
					},
				},
			},
			-- Dominate Mind
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71289,
				execute = {
					{
						"raidicon","dominatemark",
						"alert","dominatecd",
					},
					{
						"quash", "dominatewarn",
						"schedulealert", {"dominatewarn", 0.2},
					},
					-- {
						-- "expect",{"#4#","~=","&playerguid&"},
						-- "invoke",{
							-- {
								-- "expect",{"&difficulty&","==","4"}, -- == 25h
								-- "set",{dominatetext = format(L.alert["%s Cast"],SN[71289])}
							-- },
							-- {
								-- "expect",{"&difficulty&","<=","3"}, -- < 25h
								-- "set",{dominatetext = format("%s: #5#!",SN[71289])},
							-- },
						-- },
						-- "alert","dominatewarn",
					-- },
				},
			},
			-- {
				-- type = "combatevent",
				-- eventtype = "SPELL_CAST_SUCCESS",
				-- spellname = 71289,
				-- execute = {
					-- {
						-- "quash", "dominatewarn",
						-- "schedulealert", {"dominatewarn", 0.3},
					-- },
				-- },
			-- },
			-- Frostbolt
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 71420,
				srcnpcid = 36855, -- Deathwhisper
				execute = {
					{
						"alert","frostboltwarn",
					},
				},
			},
			-- Frostbolt interrupt
			{
				type = "combatevent",
				eventtype = "SPELL_INTERRUPT",
				spellname2 = 71420,
				dstnpcid = 36855, -- Deathwhisper
				execute = {
					{
						"quash","frostboltwarn",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end