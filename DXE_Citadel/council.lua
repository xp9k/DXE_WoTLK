local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- BLOOD PRINCES
---------------------------------

do
	local data = {
		version = 26,
		key = "bloodprincecouncil",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Blood Princes"],
		triggers = {
			scan = {
				37970, -- Valanar
				37972, -- Keleseth
				37973, -- Taldaram
			},
		},
		onactivate = {
			combatstop = true,
			tracerstart = true,
			unittracing = {
				"boss3", -- Valanar
				"boss2",
				"boss1",
			},
			-- They despawn instead of triggering a UNIT_DIED
			defeat = L.chat_citadel["^My queen, they"],
		},
		userdata = {
			invocationtime = {33,46.5,loop = false, type = "series"},
			shocktext = "",
			empoweredtime = 10,
			prisontext = "",
		},
		onstart = {
			{
				"alert","invocationcd",
				"alert","empoweredshockcd",
				"set",{empoweredtime = 20},
			},
		},
		alerts = {
			invocationwarn = {
				varname = format(L.alert["%s Warning"],SN[70982]),
				type = "simple",
				text = format("%s: #5#! %s!",L.alert["Invocation"],L.alert["SWAP"]),
				time = 3,
				color1 = "BROWN",
				sound = "ALERT4",
				icon = ST[70982],
			},
			invocationcd = {
				varname = format(L.alert["%s Cooldown"],SN[70982]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],L.alert["Invocation"]),
				time = "<invocationtime>",
				flashtime = 10,
				color1 = "MAGENTA",
--				sound = "ALERT3",
				icon = ST[70982],
			},
			empoweredshockwarn = {
				varname = format(L.alert["%s Casting"],SN[73037]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[73037]),
				time = 4.5,
				flashtime = 4.5,
				color1 = "GREY",
				sound = "ALERT3",
				icon = ST[73037],
				flashscreen = true,
			},
			empoweredshockcd = {
				varname = format(L.alert["%s Cooldown"],SN[73037]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[73037]),
				time = "<empoweredtime>",
				flashtime = 5,
				color1 = "BLACK",
--				sound = "ALERT5",
				icon = ST[73037],
			},
			shockwarn = {
				varname = format(L.alert["%s Cast"],SN[72037]),
				type = "simple",
				text = "<shocktext>",
				time = 6,
				color1 = "BLACK",
				sound = "ALERT2",
				icon = ST[72037],
			},
			infernoself = {
				varname = format(L.alert["%s on self"],L.alert["Inferno Flame"]),
				type = "simple",
				text = format("%s: %s! %s!",SN[39941],L.alert["YOU"],L.alert["RUN"]),
				time = 3,
				color1 = "ORANGE",
				sound = "ALERT3",
				icon = ST[62910],
				flashscreen = true,
			},
			infernowarn = {
				varname = format(L.alert["%s on others"],L.alert["Inferno Flame"]),
				type = "simple",
				text = format("%s: #5#! %s!",SN[39941],L.alert["MOVE AWAY"]),
				time = 3,
				color1 = "ORANGE",
				icon = ST[62910],
--				flashscreen = true,
			},
			shadowprisonself = {
				varname = format(L.alert["%s on self"],SN[72999]),
				type = "centerpopup",
				text = "<prisontext>",
				time = 10,
				color1 = "PURPLE",
				icon = ST[72999],
			},
			kineticbombwarn = {
				varname = format(L.alert["%s Cast"],SN[72080]),
				type = "simple",
				text = format(L.alert["%s Cast"],SN[72080]),
				time = 3,
--				sound = "ALERT6",
				color1 = "GOLD",
				throttle = 5,
				icon = ST[72080],
			},
			kineticbombcd = {
				varname = format(L.alert["%s Cooldown"],SN[72080]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[72080]),
				time = 17.7,
				time10n = 26.8,
				time10h = 26.8,
				flashtime = 10,
				color1 = "YELLOW",
				throttle = 5,
				icon = ST[72080],
			},
		},
		arrows = {
			infernoarrow = {
				varname = L.alert["Inferno Flame"],
				unit = "#5#",
				persist = 10,
				action = "TOWARD",
				msg = L.alert["MOVE TOWARD"],
				spell = L.alert["Inferno Flame"],
			},
			shockarrow = {
				varname = SN[72037],
				unit = "&tft_unitname&",
				persist = 7,
				action = "AWAY",
				msg = L.alert["MOVE AWAY"],
				spell = SN[72037],
				fixed = true,
				range1 = 11,
				range2 = 16,
				range3 = 22,
			},
		},
		windows = {
			proxwindow = true,
		},
		raidicons = {
			shockmark = {
				varname = SN[72037],
				type = "FRIENDLY",
				persist = 5,
				unit = "&tft_unitname&",
				icon = 1,
			},
			infernomark = {
				varname = L.alert["Inferno Flame"],
				type = "FRIENDLY",
				persist = 7.5,
				unit = "#5#",
				icon = 2,
			},
		},
		announces = {
			shocksay = {
				varname = format(L.alert["Say %s on self"],SN[72037]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[72037]).."!",
			},
			infernosay = {
				varname = format(L.alert["Say %s on self"],L.alert["Inferno Flame"]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],L.alert["Inferno Flame"]).."!",
			},
		},
		timers = {
			fireshock = {
				{
					"expect",{"&tft_unitexists& &tft_isplayer&","==","true true"},
					"set",{shocktext = format("%s: %s!",SN[72037],L.alert["YOU"])},
					"raidicon","shockmark",
					"alert","shockwarn",
					"announce","shocksay",
					"arrow","shockarrow",
				},
				{
					"expect",{"&tft_unitexists& &tft_isplayer&","==","true false"},
					"set",{shocktext = format("%s: &tft_unitname&!",SN[72037])},
					"raidicon","shockmark",
					"alert","shockwarn",
					"proximitycheck",{"&tft_unitname&",28},
					"arrow","shockarrow",
				},
				{
					"expect",{"&tft_unitexists&","==","false"},
					"set",{shocktext = format(L.alert["%s Cast"],SN[72037])},
					"alert","shockwarn",
				},
			},
		},
		events = {
			-- Shadow Prison
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72999,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{prisontext = format("%s: %s!",SN[72999],L.alert["YOU"])},
						"alert","shadowprisonself",
					},
				},
			},
			-- Shadow Prison applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 72999,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{prisontext = format("%s: %s! %s!",SN[72999],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"quash","shadowprisonself",
						"alert","shadowprisonself",
					},
				},
			},
			-- Shadow Prison removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 72999,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","shadowprisonself",
					},
				},
			},

			-- Shock Vortex
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72037,
				execute = {
					{
						"scheduletimer",{"fireshock",0.2},
					},
				},
			},
			-- Inferno Flames
			{
				type = "event",
				event = "EMOTE",
				execute = {
					{
						"expect",{"#1#","find",L.chat_citadel["^Empowered Flames speed"]},
						"raidicon","infernomark",
						"expect",{"#5#","==","&playername&"},
						"alert","infernoself",
						"announce","infernosay",
					},
					{
						"expect",{"#1#","find",L.chat_citadel["^Empowered Flames speed"]},
						"expect",{"#5#","~=","&playername&"},
						"alert","infernowarn",
						"arrow","infernoarrow",
					},
				},
			},
			-- Invocation of Blood
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70952,
				execute = {
					{
						"alert","invocationcd",
						"alert","invocationwarn",
					},
					{
						"expect",{"&npcid|#4#&","==","37970"}, -- Valanar
						"set",{empoweredtime = 6},
						"alert","empoweredshockcd",
						"set",{empoweredtime = 20},
					},
					{
						"expect",{"&npcid|#4#&","~=","37970"}, -- Valanar
						"quash","empoweredshockcd",
					},
				}
			},
			-- Empowered Shock
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 73037,
				execute = {
					{
						"quash","empoweredshockcd",
						"alert","empoweredshockcd",
						"alert","empoweredshockwarn",
					},
				},
			},
			-- Kinetic Bomb
			{
				type = "event",
				event = "UNIT_SPELLCAST_SUCCEEDED",
				execute = {
					{
						"expect",{"#2#","==",SN[72080]},
						"alert","kineticbombwarn",
						"alert","kineticbombcd",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end