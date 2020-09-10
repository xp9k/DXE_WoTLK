local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- PUTRICIDE
---------------------------------

do
	local data = {
		version = 43,
		key = "putricide",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Putricide"],
		triggers = {
			scan = {
				36678, -- Putricide
			},
		},
		onactivate = {
			tracerstart = true,
			combatstop = true,
			tracing = {36678},
			defeat = 36678,
		},
		onstart = {
			{
				"alert","enragecd",
				"alert","unstableexperimentcd",
				"alert","puddlecd",
				"set",{experimenttime = 37.5, puddletime = 35},
			},
		},
		userdata = {
			oozeaggrotext = {format(L.alert["%s Aggros"],L.npc_citadel["Volatile Ooze"]),format(L.alert["%s Aggros"],L.npc_citadel["Gas Cloud"]),loop = true, type = "series"},
			experimenttime = 25,
			malleabletime = 6,
			gasbombtime = 16,
			transitioned = "0",
			malleabletext = "",
			mutatedtext = "",
			puddletime = 10,
			puddletimeaftertransition = {10,15,loop = false, type = "series"},
			puddletimeperphase = {35,20,loop = false, type = "series"},
			plaguetimeaftertrans = {50,50,loop = false, type = "series"},
			plaguetime = 60,
			concocted = 0,
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
			unstableexperimentwarn = {
				varname = format(L.alert["%s Casting"],SN[71966]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[71966]),
				sound = "ALERT2",
				color1 = "MAGENTA",
				time = 2.5,
				flashtime = 2.5,
				icon = ST[71966],
			},
			unstableexperimentcd = {
				varname = format(L.alert["%s Cooldown"],SN[71966]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71966]),
				time = "<experimenttime>",
				flashtime = 10,
				color1 = "PINK",
				icon = ST[71966],
			},
			mutatedslimeself = {
				varname = format(L.alert["%s on self"],SN[72456]),
				type = "simple",
				text = format("%s: %s!",SN[72456],L.alert["YOU"]),
				color1 = "GREEN",
				time = 3,
				sound = "ALERT2",
				icon = ST[72456],
				flashscreen = true,
				throttle = 4,
			},
			oozeaggrocd = {
				varname = format(L.alert["%s Timer"],format(L.alert["%s Aggros"],L.npc_citadel["Volatile Ooze"].."/"..L.npc_citadel["Gas Cloud"])),
				type = "centerpopup",
				text = "<oozeaggrotext>",
				color1 = "ORANGE",
				time = 8.5, -- 11 from Unstable Experiment Cast
				flashtime = 8.5,
				icon = ST[72218],
			},
			oozeadhesivecastwarn = {
				varname = format(L.alert["%s Casting"],SN[72836]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[72836]),
				time = 3,
				color1 = "DCYAN",
				sound = "ALERT4",
				icon = ST[72836],
			},
			oozeadhesiveappwarn = {
				varname = format(L.alert["%s on others"],SN[72836]),
				type = "simple",
				text = format("%s: #5#!",SN[72836]),
				color1 = "CYAN",
--				sound = "ALERT3",
				time = 3,
				icon = ST[72836],
				flashscreen = true,
			},
			bloatcastwarn = {
				varname = format(L.alert["%s Casting"],SN[72455]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[72455]),
				time = 3,
				color1 = "BROWN",
				icon = ST[72455],
			},
			bloatappself = {
				varname = format(L.alert["%s on self"],SN[72455]),
				type = "simple",
				text = format("%s: %s! %s!",SN[72455],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				sound = "ALERT3",
				color1 = "BROWN",
				icon = ST[72455],
				flashscreen = true,
			},
			bloatappwarn = {
				varname = format(L.alert["%s on others"],SN[72455]),
				type = "simple",
				text = format("%s: #5#!",SN[72455]),
				time = 3,
				sound = "ALERT4",
				color1 = "BROWN",
				icon = ST[72455],
			},
			gasbombwarn = {
				varname = format(L.alert["%s Explodes"],SN[71255]),
				type = "centerpopup",
				text = format(L.alert["%s Explodes"],SN[71255]),
				time = 10,
--				sound = "ALERT5",
				color1 = "YELLOW",
				icon = ST[71255],
			},
			gasbombcd = {
				varname = format(L.alert["%s Cooldown"],SN[71255]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71255]),
				time = "<gasbombtime>",
				flashtime = 5,
				color1 = "GOLD",
				icon = ST[71255],
			},
			malleablegoowarn = {
				varname = format(L.alert["%s Warning"],SN[72615]),
				type = "simple",
				text = "<malleabletext>",
				time = 3,
				sound = "ALERT4",
				color1 = "BLACK",
				icon = ST[72615],
			},
			malleablegoocd = {
				varname = format(L.alert["%s Cooldown"],SN[72615]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[72615]),
				time = "<malleabletime>",
				flashtime = 5,
				color1 = "GREY",
				icon = ST[72615],
			},
			teargaswarn = {
				varname = format(L.alert["%s Casting"],SN[71617]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[71617]),
				time = 2.5,
--				sound = "ALERT7",
				color1 = "INDIGO",
				icon = ST[71617],
			},
			teargasdur = {
				varname = format(L.alert["%s Duration"],SN[71617]),
				type = "centerpopup",
				text = format(L.alert["%s Ends Soon"],SN[71617]),
				time = 16,
				color1 = "INDIGO",
				icon = ST[71617],
			},
			mutatedwarn = {
				varname = format(L.alert["%s Warning"],SN[72463]),
				type = "simple",
				text = "<mutatedtext>",
				time = 3,
--				sound = "ALERT8",
				icon = ST[72463],
			},
			mutatedcd = {
				varname = format(L.alert["%s Cooldown"],SN[72463]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[72463]),
				time = 10,
				flashtime = 10,
				color1 = "RED",
				icon = ST[72463],
			},
			puddlecd = {
				varname = format(L.alert["%s Cooldown"],SN[70343]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[70343]),
				time = "<puddletime>",
				flashtime = 10,
				color1 = "TAN",
				throttle = 10,
				icon = ST[70341],
			},
			unboundplagueself = {
				varname = format(L.alert["%s on self"],SN[72855]),
				type = "centerpopup",
				text = format("%s: %s!",SN[72855],L.alert["YOU"]),
				time = 10,
				color1 = "WHITE",
				icon = ST[72855],
				flashscreen = true,
			},
			unboundplaguecd = {
				varname = format(L.alert["%s Cooldown"],SN[72855]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[72855]),
				time = "<plaguetime>",
				flashtime = 10,
				color1 = "MIDGREY",
				icon = ST[72855],
			},
			putricideaggrocd = {
				varname = format(L.alert["%s Aggros"],L.npc_citadel["Putricide"]),
				type = "centerpopup",
				text = format(L.alert["%s Aggros"],L.npc_citadel["Putricide"]),
				color1 = "PEACH",
				time = 10,
				flashtime = 10,
				color1 = "TAN",
				icon = "Interface\\Icons\\Achievement_Boss_ProfPutricide",
			},
		},
		raidicons = {
			oozeadhesivemark = {
				varname = SN[72836],
				type = "FRIENDLY",
				persist = 30,
				unit = "#5#",
				icon = 1,
			},
			gaseousbloatmark = {
				varname = SN[72455],
				type = "FRIENDLY",
				persist = 30,
				unit = "#5#",
				icon = 2,
			},
			malleablemark = {
				varname = SN[72615],
				type = "FRIENDLY",
				persist = 5,
				unit = "&tft_unitname&",
				icon = 3,
			},
			unboundplaguemark = {
				varname = SN[72855],
				type = "FRIENDLY",
				persist = 20,
				unit = "#5#",
				icon = 4,
			},
		},
		arrows = {
			malleablearrow = {
				varname = SN[72615],
				unit = "&tft_unitname&",
				persist = 5,
				action = "AWAY",
				msg = L.alert["MOVE AWAY"],
				spell = SN[72615],
				fixed = true,
				range1 = 7,
				range2 = 10,
				range3 = 14,
			},
		},
		announces = {
			malleablegoosay = {
				varname = format(L.alert["Say %s on self"],SN[72615]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[72615]).."!",
			},
			plaguesay = {
				varname = format(L.alert["Say %s on self"],SN[72855]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[72855]).."!",
			},
		},
		timers = {
			fireoozeaggro = {
				{
					"alert","oozeaggrocd",
				},
			},
			firemalleable = {
				{
					"expect",{"&tft_unitexists& &tft_isplayer&","==","true true"},
					"set",{malleabletext = format("%s: %s!",SN[72615],L.alert["YOU"])},
					"raidicon","malleablemark",
					"alert","malleablegoowarn",
					"announce","malleablegoosay",
					"arrow","malleablearrow",
				},
				{
					"expect",{"&tft_unitexists& &tft_isplayer&","==","true false"},
					"set",{malleabletext = format("%s: &tft_unitname&!",SN[72615])},
					"raidicon","malleablemark",
					"arrow","malleablearrow",
					"alert","malleablegoowarn",
				},
				{
					"expect",{"&tft_unitexists&","==","false"},
					"set",{malleabletext = format(L.alert["%s Cast"],SN[72615])},
					"alert","malleablegoowarn",
				},
			},
			fireputraggro = {
				{
					"alert","putricideaggrocd",
				},
			},
			heroictrans = {
				{
					"set",{malleabletime = 6, experimenttime = 20, gasbombtime = 11, puddletime = "<puddletimeaftertransition>", plaguetime = "<plaguetimeaftertrans>"},
					"alert","malleablegoocd",
					"alert","gasbombcd",
					"alert","puddlecd",
					"alert","unboundplaguecd",
					"set",{malleabletime = 20, experimenttime = 37.5, gasbombtime = 35.5, puddletime = "<puddletimeperphase>", plaguetime = 60},
					"expect",{"<transitioned>","==","0"},
					"alert","unstableexperimentcd",
					"set",{transitioned = "1"},
				},
			},
		},
		events = {
			-- Slime Puddle
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 70341,
				execute = {
					{
						"alert","puddlecd",
					},
				},
			},
			-- Mutated Plague
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72463,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{mutatedtext = format("%s: %s!",SN[72463],L.alert["YOU"])},
						"quash","mutatedcd",
						"alert","mutatedwarn",
						"alert","mutatedcd",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"set",{mutatedtext = format("%s: #5#!",SN[72463])},
						"quash","mutatedcd",
						"alert","mutatedwarn",
						"alert","mutatedcd",
					},
				},
			},
			-- Mutated Plague stacks
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 72463,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{mutatedtext = format("%s: %s! %s!",SN[72463],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"quash","mutatedcd",
						"alert","mutatedwarn",
						"alert","mutatedcd",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"set",{mutatedtext = format("%s: #5#! %s!",SN[72463],format(L.alert["%s Stacks"],"#11#")) },
						"quash","mutatedcd",
						"alert","mutatedwarn",
						"alert","mutatedcd",
					},
				},
			},
			-- Malleable Goo
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 72615,
				execute = {
					{
						"quash","malleablegoocd",
						"alert","malleablegoocd",
						"scheduletimer",{"firemalleable",0.2},
					},
				},
			},
			-- Choking Gas Bomb
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 71255,
				execute = {
					{
						"quash","gasbombcd",
						"alert","gasbombwarn",
						"alert","gasbombcd",
					},
				},
			},
			-- Tear Gas
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 71617,
				execute = {
					{
						"quash","puddlecd",
						"quash","oozeaggrocd", -- don't cancel timer
						"quash","malleablegoocd",
						"quash","unstableexperimentcd",
						"quash","gasbombcd",
						"alert","teargaswarn",
					},
				},
			},
			-- Volatile Experiment
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72843,
				execute = {
					{
						"quash","puddlecd",
						"quash","oozeaggrocd", -- don't cancel timer
						"quash","malleablegoocd",
						"quash","unstableexperimentcd",
						"quash","gasbombcd",
						"quash","unboundplaguecd",
					},
				},
			},
			-- Tear Gas duration
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71615,
				throttle = 3,
				execute = {
					{
						"alert","teargasdur",
					},
				},
			},
			-- Tear Gas removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 71615,
				throttle = 3,
				dstisplayertype = true,
				execute = {
					{
						"set",{malleabletime = 6, experimenttime = 20, gasbombtime = 16, puddletime = "<puddletimeaftertransition>"},
						"alert","malleablegoocd",
						"alert","gasbombcd",
						"alert","puddlecd",
						"set",{malleabletime = 25.5, experimenttime = 37.5, gasbombtime = 35.5, puddletime = "<puddletimeperphase>"},
						"expect",{"<transitioned>","==","0"},
						"alert","unstableexperimentcd",
						"set",{transitioned = "1"},
					},
				},
			},
			-- Create Concoction/Guzzle Potions
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = {
					72851, -- Create Concoction
					73121, -- Guzzle Potions
				},
				execute = {
					{
						"expect",{"<concocted>","==","0"},
						"scheduletimer",{"fireputraggro",30},
						"scheduletimer",{"heroictrans",40}, -- 30s cast + 10s wait time
					},
					{
						"expect",{"<concocted>","==","1"},
						"invoke",{
							{
								"expect",{"&difficulty&","<=","3"},
								"scheduletimer",{"fireputraggro",30},
								"scheduletimer",{"heroictrans",40}, -- 30s cast + 10s wait time
							},
							{
								"expect",{"&difficulty&","==","4"},
								"scheduletimer",{"fireputraggro",20},
								"scheduletimer",{"heroictrans",30}, -- 20s cast + 10s wait time
							},
						},
					},
					{
						"set",{concocted = 1},
					},
				},
			},
			-- Gaseous Bloat
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellid = {
					70672, -- 10
					72455, -- 25
					72832, -- 10h
					72833, -- 25h
				},
				execute = {
					{
						"quash","oozeaggrocd",
						"alert","bloatcastwarn",
					},
				},
			},
			-- Gaseous Bloat application
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = {
					70672, -- 10
					72455, -- 25
					72832, -- 10h
					72833, -- 25h
				},
				execute = {
					{
						"raidicon","gaseousbloatmark",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","bloatappself",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert","bloatappwarn",
					},
				},
			},
			-- Gaseous Bloat removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 72455,
				execute = {
					{
						"removeraidicon","#5#",
					},
				},
			},
			-- Volatile Ooze Adhesive
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72836,
				execute = {
					{
						"quash","oozeaggrocd",
						"alert","oozeadhesivecastwarn",
					},
				},
			},
			-- Volatile Ooze Adhesive application
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72836,
				execute = {
					{
						"raidicon","oozeadhesivemark",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"quash","oozeadhesivecastwarn",
						"alert","oozeadhesiveappwarn",
					},
				},
			},
			-- Volatile Ooze Adhesive removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 72836,
				execute = {
					{
						"removeraidicon","#5#",
					},
				},
			},
			-- Unstable Experiment
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 71966,
				execute = {
					{
						"quash","unstableexperimentcd",
						"alert","unstableexperimentwarn",
						"alert","unstableexperimentcd",
						"scheduletimer",{"fireoozeaggro",2.5},
					},
				},
			},
			-- Mutated Slime self
			{
				type = "combatevent",
				eventtype = "SPELL_DAMAGE",
				spellname = {
					72456, -- Mutated Slime
					72869, -- Slime Puddle
				},
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","mutatedslimeself",
					},
				},
			},
			-- Unbound Plague
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 72855,
				execute = {
					{
						"alert","unboundplaguecd",
					},
				},
			},
			-- Unbound Plague application
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72855,
				execute = {
					{
						"raidicon","unboundplaguemark",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","unboundplagueself",
						"announce","plaguesay",
					},
				},
			},
			-- Unbound Plague application removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 72855,
				dstisplayerunit = true,
				execute = {
					{
						"quash","unboundplagueself",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end
