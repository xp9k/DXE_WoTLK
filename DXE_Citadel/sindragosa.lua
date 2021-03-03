local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- SINDRAGOSA
---------------------------------

do
	local data = {
		version = 39,
		key = "sindragosa",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Sindragosa"],
		triggers = {
			scan = {36853}, -- Sindragosa
		},
		onactivate = {
			tracerstart = true,
			combatstop = true,
			tracing = {36853}, -- Sindragosa
			defeat = 36853, -- Sindragosa
		},
		userdata = {
			chilledtext = "",
			airtime = {50,110,loop = false, type = "series"},
			phase = "1",
			instabilitytext = "",
			unchainedtime = 30,
			frostbeacontext = "",
			icygriptime = 30.5,
			tailsmashtime = 27,
			bombcount = "1",
			breathtime = 5.5,
		},
		onstart = {
			{
				"alert","enragecd",
				"alert","aircd",
				"alert","frostbreathcd",
				"alert","icygripcd",
				"set",{breathtime = 21.5, icygriptime = 77.4, unchainedtime = 12},
				"alert", "unchainedcd",
			},
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
			icetombwarn = {
				varname = format(L.alert["%s Casting"],SN[69712]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[69712]),
				time = 1,
				flashtime = 1,
				color1 = "INDIGO",
				sound = "ALERT1",
				icon = ST[69712],
			},
			frostbeacondur = {
				varname = format(L.alert["%s Duration"],SN[70126]),
				type = "centerpopup",
				text = "<frostbeacontext>",
				time = 7,
				flashtime = 7,
				color1 = "GOLD",
				throttle = 2,
				icon = ST[70126],
			},
			frostbeaconwarn = {
				varname = format(L.alert["%s Warning"],SN[70126]),
				type = "simple",
				text = format("%s: &debuffednames|"..SN[70126].."&", SN[70126]),
				time = 7,
				flashtime = 7,
				color1 = "GOLD",
				flashscreen = true,
				sound = "ALERT2",
				icon = ST[70126],
			},
			frostbeaconself = {
				varname = format(L.alert["%s on self"],SN[70126]),
				type = "simple",
				text = format("%s: %s!",SN[70126],L.alert["YOU"]).."!",
				time = 3,
				icon = ST[70126],
				sound = "ALERT3",
				flashscreen = true,
			},
			icygripcd = {
				varname = format(L.alert["%s Cooldown"],SN[70117]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[70117]),
				time = "<icygriptime>",
				flashtime = 10,
				color1 = "GREY",
				icon = ST[70117],
			},
			blisteringcoldwarn = {
				varname = format(L.alert["%s Casting"],SN[71047]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[71047]),
				time = 5,
				flashtime = 5,
				color1 = "ORANGE",
--				sound = "ALERT2",
				icon = ST[71047],
			},
			unchainedself = {
				varname = format(L.alert["%s on self"],SN[69762]),
				type = "centerpopup",
				text = format("%s: %s! %s!",SN[69762],L.alert["YOU"],L.alert["CAREFUL"]),
				time = 30,
				flashtime = 30,
				color1 = "TURQUOISE",
				flashscreen = true,
				sound = "ALERT2",
				icon = ST[69762],
			},
			unchainedwarn = {
				varname = format(L.alert["%s Warning"],SN[69762]),
				type = "simple",
				text = format("%s: &debuffednames|"..SN[69762].."&", SN[69762]),
				time = 5,
				flashtime = 5,
				color1 = "TURQUOISE",
				flashscreen = true,
				sound = "ALERT2",
				icon = ST[69762],
			},
			unchainedcd = {
				varname = format(L.alert["%s Cooldown"],SN[69762]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69762]),
				time = "<unchainedtime>",
				flashtime = 10,
				color1 = "WHITE",
--				sound = "ALERT5",
				icon = ST[69762],
			},
			instabilityself = {
				varname = format(L.alert["%s on self"],SN[69766]),
				type = "centerpopup",
				text = "<instabilitytext>",
				time = 5,
				flashtime = 4,
				color1 = "VIOLET",
				icon = ST[69766],
			},
			chilledstackself = {
				varname = format(L.alert["%s Stacks"],L.alert["Chilled"]).." >= 4",
				type = "simple",
				text = format("%d "..L.alert["%s Stacks"].."! %s!",4,L.alert["Chilled"],L.alert["CAREFUL"]),
				time = 3,
				color1 = "CYAN",
				sound = "ALERT1",
				icon = ST[70106],
				flashscreen = true,
			},
			chilledself = {
				varname = format(L.alert["%s on self"],L.alert["Chilled"]),
				type = "centerpopup",
				text = "<chilledtext>",
				time = 8,
				flashtime = 8,
				color1 = "CYAN",
				icon = ST[70106],
			},
			aircd = {
				varname = format(L.alert["%s Cooldown"],L.alert["Air Phase"]),
				type = "dropdown",
				text = format(L.alert["Next %s"],L.alert["Air Phase"]),
				time = "<airtime>",
				flashtime = 10,
				color1 = "YELLOW",
				icon = "Interface\\Icons\\INV_Misc_Toy_09",
			},
			airdur = {
				varname = format(L.alert["%s Duration"],L.alert["Air Phase"]),
				type = "dropdown",
				text = L.alert["Air Phase"],
				time = 47,
				flashtime = 10,
				color1 = "MAGENTA",
				icon = "Interface\\Icons\\INV_Misc_Toy_09",
			},
			frostbombwarn = {
				varname = format(L.alert["%s ETA"],SN[71053]),
				type = "centerpopup",
				text = format(L.alert["%s Hits"],SN[71053]).." <bombcount>",
				time = 5.85, -- average: ranges from 5.3 to 6.5
				flashtime = 5.85,
				color1 = "BLUE",
--				sound = "ALERT5",
				icon = ST[71053],
				throttle = 3,
			},
			frostbreathwarn = {
				varname = format(L.alert["%s Casting"],SN[71056]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[71056]),
				time = 1.5,
				flashtime = 1.5,
				color1 = "BROWN",
				sound = "ALERT4",
				icon = ST[71056],
			},
			frostbreathcd = {
				varname = format(L.alert["%s Cooldown"],SN[71056]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71056]),
				time = "<breathtime>",
				flashtime = 5,
				color1 = "BLUE",
				icon = ST[71056],
			},
			mysticbuffetcd = {
				varname = format(L.alert["%s Timer"],SN[72528]),
				type = "centerpopup",
				text = format(L.alert["Next %s"],SN[72528]),
				time = 6,
				color1 = "PINK",
				icon = ST[72528],
				throttle = 4,
			},
			tailsmashcd = {
				varname = format(L.alert["%s Cooldown"],SN[71077]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71077]),
				time = "<tailsmashtime>",
				flashtime = 10,
				color1 = "BLACK",
				icon = ST[71077],
			},
		},
		announces = {
			beaconsay = {
				varname = format(L.alert["Say %s on self"],SN[70126]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[70126]).."!",
			},
		},
		windows = {
			proxwindow = true,
		},
		raidicons = {
			frostbeaconmark = {
				varname = SN[70126],
				type = "MULTIFRIENDLY",
				persist = 7,
				reset = 2,
				unit = "#5#",
				icon = 1,
				total = 6,
			},
		},
		arrows = {
			westarrow = {
				varname = format(L.alert["%s Beacon Position"],L.alert["West"]),
				unit = "player",
				persist = 7,
				action = "TOWARD",
				msg = L.alert["MOVE THERE"],
				spell = L.alert["West"],
				fixed = true,
				xpos = 0.35448017716408,
				ypos = 0.23266260325909,
			},
			northarrow = {
				varname = format(L.alert["%s Beacon Position"],L.alert["North"]),
				unit = "player",
				persist = 7,
				action = "TOWARD",
				msg = L.alert["MOVE THERE"],
				spell = L.alert["North"],
				fixed = true,
				xpos = 0.3654870390892,
				ypos = 0.2162726521492,
			},
			eastarrow = {
				varname = format(L.alert["%s Beacon Position"],L.alert["East"]),
				unit = "player",
				persist = 7,
				action = "TOWARD",
				msg = L.alert["MOVE THERE"],
				spell = L.alert["East"],
				fixed = true,
				xpos = 0.37621337175369,
				ypos = 0.23285666108131,
			},
			southarrow = {
				varname = format(L.alert["%s Beacon Position"],L.alert["South"]),
				unit = "player",
				persist = 7,
				action = "TOWARD",
				msg = L.alert["MOVE THERE"],
				spell = L.alert["South"],
				fixed = true,
				xpos = 0.36525920033455,
				ypos = 0.250081539154054,
			},
			southsoutharrow = {
				varname = format(L.alert["%s Beacon Position"],L.alert["South"].." "..L.alert["South"]),
				unit = "player",
				persist = 7,
				action = "TOWARD",
				msg = L.alert["MOVE THERE"],
				spell = L.alert["South"].." "..L.alert["South"],
				fixed = true,
				xpos = 0.36546084284782,
				ypos = 0.27346137166023,
			},
			easteastarrow = {
				varname = format(L.alert["%s Beacon Position"],L.alert["East"].." "..L.alert["East"]),
				unit = "player",
				persist = 7,
				action = "TOWARD",
				msg = L.alert["MOVE THERE"],
				spell = L.alert["East"].." "..L.alert["East"],
				fixed = true,
				xpos = 0.39097648859024,
				ypos = 0.23303273320198,
			},
			beaconarrow = {
				varname = format("%s %s",SN[70126],L.alert["Phase Three"]),
				unit = "#5#",
				persist = 7,
				action = "AWAY",
				msg = L.alert["MOVE AWAY"],
				spell = SN[70126],
			},
		},
		timers = {
			checkbeacon = {
				{
					-- This is dependent on multi raid icons being set and consistent across all users
					-- Icon positioning is the following:
					--     1
					--
					-- 3       4    6
					--
					--     2
					--
					--     5
					"expect",{"&playerdebuff|"..SN[70126].."&","==","true"},
					"invoke",{
						{
							"expect",{"&hasicon|player|1&","==","true"}, -- Skull
							"arrow","northarrow",
						},
						{
							"expect",{"&hasicon|player|2&","==","true"}, -- Cross
							"arrow","southarrow",
						},
						{
							"expect",{"&hasicon|player|3&","==","true"}, -- Square
							"arrow","westarrow",
						},
						{
							"expect",{"&hasicon|player|4&","==","true"}, -- Moon
							"arrow","eastarrow",
						},
						{
							"expect",{"&hasicon|player|5&","==","true"}, -- Triangle
							"arrow","southsoutharrow",
						},
						{
							"expect",{"&hasicon|player|6&","==","true"}, -- Diamond
							"arrow","easteastarrow",
						},
					},
				},
			},
			firefrostbomb = {
				{
					"set",{bombcount = "INCR|1"},
					"alert","frostbombwarn",
					"expect",{"<bombcount>","<","4"},
					"scheduletimer",{"firefrostbomb",6.4},
				},
			},
		},
		events = {
			-- Tail Smash
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 71077,
				execute = {
					{
						"alert","tailsmashcd",
					},
				},
			},
			-- Mystic Buffet
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72529,
				execute = {
					{
						"expect",{"&timeleft|mysticbuffetcd&","<","3"},
						"quash","mysticbuffetcd",
					},
					{
						"alert","mysticbuffetcd",
					},
				},
			},
			-- Mystic Buffet
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 72529,
				execute = {
					{
						"expect",{"&timeleft|mysticbuffetcd&","<","3"},
						"quash","mysticbuffetcd",
					},
					{
						"alert","mysticbuffetcd",
					},
				},
			},
			{
				type = "event",
				event = "YELL",
				execute = {
					-- Air phase
					{
						"expect",{"#1#","find",L.chat_citadel["^Your incursion ends here"]},
						"quash","aircd",
						"quash","unchainedcd",
						"quash","tailsmashcd",
						"quash","frostbreathcd",
						"set",{unchainedtime = 55, tailsmashtime = 61, breathtime = 53},
						"alert","unchainedcd",
						"alert","tailsmashcd",
						"alert","frostbreathcd",
						"alert","icygripcd",
						"set",{unchainedtime = 30, tailsmashtime = 27, breathtime = 21.5},
						"alert","aircd",
						"alert","airdur",
					},
					-- Last Phase
					{
						"expect",{"#1#","find",L.chat_citadel["^Now, feel my master's limitless power"]},
						"quash","frostbreathcd",
						"quash","aircd",
						"quash","icygripcd",
						"set",{phase = "2", unchainedtime = 80, breathtime = 8, icygriptime = 33.7},
						"alert","frostbreathcd",
						"alert","icygripcd",
						"set",{breathtime = 21.5, icygriptime = 60},
						"tracing",{36853,36980}, -- Sindragosa, Ice Tomb
					},
				},
			},
			-- Ice Tomb
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69712,
				execute = {
					{
						"alert","icetombwarn",
					},
				},
			},
			-- Ice Tomb app
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70157,
				execute = {
					{
						-- fires 2 to 5 times within 0.1 seconds
						"expect",{"<phase>","==","1"},
						"set",{bombcount = "1"},
						"alert","frostbombwarn",
						"scheduletimer",{"firefrostbomb",6.4},
					},
				},
			},
			-- Frost Beacon
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70126,
				execute = {
					{
						"expect",{"<phase>","==","1"},
						"set",{frostbeacontext = format(L.alert["%s Duration"],SN[70126])},
					},
					{
						"expect",{"<phase>","==","2"},
						"invoke",{
							{
								"expect",{"#4#","~=","&playerguid&"},
								"set",{frostbeacontext = format("%s: #5#!",SN[70126])},
								"arrow","beaconarrow",
							},
							{
								"expect",{"#4#","==","&playerguid&"},
								"set",{frostbeacontext = format("%s: %s!",SN[70126],L.alert["YOU"])},
							},
						}
					},
					{
						"raidicon","frostbeaconmark",
						"alert","frostbeacondur",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","frostbeaconself",
						"announce","beaconsay",
						"expect",{"<phase>","==","1"},
						"invoke",{
							{
								"expect",{"&difficulty&","==","4"}, -- 25h
								"scheduletimer",{"checkbeacon",0.2}, -- allow time for raid icon to set
							},
							{
								"expect",{"&difficulty&","==","2"}, -- 25
								"scheduletimer",{"checkbeacon",0.2}, -- allow time for raid icon to set
							},
							{
								"schedulealert", {"frostbeaconwarn", 0.2},
							},
						},
					},
				},
			},
			-- Frost Beacon removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 70126,
				execute = {
					{
						"removeraidicon","#5#",
					},
				},
			},
			-- Icy Grip
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 70117,
				execute = {
					{
						"expect",{"<phase>","==","2"},
						"alert","icygripcd",
					},
				},
			},
			-- Blistering Cold
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 70123,
				execute = {
					{
						"alert","blisteringcoldwarn",
					},
				},
			},
			-- Unchained Magic
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 69762,
				execute = {
					{
						"alert","unchainedcd",
					},
				},
			},
			-- Unchained Magic application
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69762,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","unchainedself",
					},
					{
						"quash", "unchainedwarn",
						"schedulealert", {"unchainedwarn", 0.2},
					},
				},
			},
			-- Instability
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69766,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{instabilitytext = format("%s: %s!",SN[69766],L.alert["YOU"])},
						"alert","instabilityself",
					},
				},
			},
			-- Instability applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 69766,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","instabilityself",
						"set",{instabilitytext = format("%s: %s! %s!",SN[69766],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"alert","instabilityself",
					},
				},
			},
			-- Instability removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 69766,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","instabilityself",
					},
				},
			},
			-- Chilled to the Bone
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70106,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{chilledtext = format("%s: %s!",L.alert["Chilled"],L.alert["YOU"])},
						"alert","chilledself",
					},
				},
			},
			-- Chilled to the Bone applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 70106,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","chilledself",
						"set",{chilledtext = format("%s: %s! %s!",L.alert["Chilled"],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"alert","chilledself",
						"expect",{"#11#",">=","4"},
						"alert","chilledstackself",
					},
				},
			},
			-- Frost Breath
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69649,
				execute = {
					{
						"quash","frostbreathcd",
						"alert","frostbreathwarn",
						"alert","frostbreathcd",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end
