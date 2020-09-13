local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- HALION
---------------------------------

do
	local data = {
		version = 15,
		key = "halion",
		zone = L.zone["The Ruby Sanctum"],
		category = L.zone["Ruby"],
		name = L.npc_ruby["Halion"],
		triggers = {
			scan = {
				39863, -- Halion
				40142, -- Twilight Halion
			},
		},
		onactivate = {
			tracerstart = true,
			combatstop = true,
			unittracing = { "boss1", "boss2" },
			defeat = L.chat_ruby["^Relish this victory, mortals, for it will"],
		},
		userdata = {
			phase = 1,
		},
		onstart = {
			{
				"alert","meteorcd",
				"alert","debuffcd",
			},
		},
		alerts = {
			fierydur = {
				varname = format(L.alert["%s Duration"],SN[74562]),
				type = "centerpopup",
				text = format("%s: #5#",SN[74562]),
				time = 30,
				flashtime = 30,
				color1 = "RED",
				icon = ST[74562],
			},
			fieryself = {
				varname = format(L.alert["%s on self"],SN[74562]),
				type = "centerpopup",
				text = format("%s: %s!",SN[74562],L.alert["YOU"]).."!",
				time = 30,
				flashtime = 30,
				color1 = "RED",
				sound = "ALERT1",
				icon = ST[74562],
				flashscreen = true,
			},
			souldur = {
				varname = format(L.alert["%s Duration"],SN[74792]),
				type = "centerpopup",
				text = format("%s: #5#",SN[74792]),
				time = 30,
				flashtime = 30,
				color1 = "PURPLE",
				icon = ST[74792],
			},
			soulself = {
				varname = format(L.alert["%s on self"],SN[74792]),
				type = "centerpopup",
				text = format("%s: %s!",SN[74792],L.alert["YOU"]).."!",
				time = 30,
				flashtime = 30,
				color1 = "PURPLE",
				sound = "ALERT2",
				icon = ST[74792],
				flashscreen = true,
			},
			cutterdur = {
				varname = format(L.alert["%s Duration"],SN[77844]),
				type = "centerpopup",
				text = SN[77844],
				time = 11,
				flashtime = 11,
				color1 = "PINK",
				icon = ST[77844],
				behavior = "overwrite",
			},
			cutterwarn = {
				varname = format(L.alert["%s Casting"],SN[77844]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[77844]),
				time = 4.5,
				flashtime = 4.5,
				color1 = "PINK",
				icon = ST[77844],
				sound = "ALERT12",
				flashscreen = true,
				behavior = "overwrite",
			},
			cuttercd = {
				varname = format(L.alert["%s Cooldown"],SN[77844]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[77844]),
				time = 30, -- time from cutter to cutter
				time2 = 35, -- initial
				flashtime = 10,
				color1 = "PINK",
				icon = ST[77844],
				behavior = "overwrite",
			},
			meteorwarn = {
				varname = format(L.alert["%s Warning"],SN[75878]),
				type = "centerpopup",
				text = format(L.alert["%s Soon"],SN[75878]).."!",
				time = 5,
				flashtime = 5,
				color1 = "ORANGE",
				sound = "ALERT4",
				icon = ST[75878],
			},
			meteorcd = {
				varname = format(L.alert["%s Cooldown"],SN[75878]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[75878]),
				time = { 20,40, loop=false, type="series"}, -- phase 1
				time2 = 30, -- phase 3 restart time
				flashtime = 10,
				color1 = "ORANGE",
				icon = ST[75878],
			},
			combustionself = {
				varname = format(L.alert["%s on self"],SN[75884]),
				type = "simple",
				text = format("%s: %s! %s!",SN[75884],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				throttle = 4,
				flashscreen = true,
				sound = "ALERT5",
				icon = ST[75884],
			},
			consumptionself = {
				varname = format(L.alert["%s on self"],SN[75876]),
				type = "simple",
				text = format("%s: %s! %s!",SN[75876],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				throttle = 4,
				flashscreen = true,
				sound = "ALERT5",
				icon = ST[75876],
			},
			meteorself = {
				varname = format(L.alert["%s on self"],SN[75952]),
				type = "simple",
				text = format("%s: %s! %s!",SN[75952],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				throttle = 4,
				flashscreen = true,
				sound = "ALERT5",
				icon = ST[75952],
			},
			debuffcd = {
				varname =  format(L.alert["%s Cooldown"],SN[74562].."/"..SN[74792]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[74562]),
				text2 = format(L.alert["%s Cooldown"],SN[74792]),
				text3 = format(L.alert["%s Cooldown"],L.alert["Fiery"].."/"..L.alert["Soul"]),
				time = { 15,25, loop=false, type="series"},
				time10h = { 15,20, loop=false, type="series"},
				time25h = { 15,20, loop=false, type="series"},
				flashtime = 10,
				color1 = "YELLOW",
				icon = ST[32786],
				behavior = "overwrite",
			},
		},
		raidicons = {
			fierymark = {
				varname = SN[74562],
				type = "FRIENDLY",
				persist = 30,
				unit = "#5#",
				icon = 1,
			},
			soulmark = {
				varname = SN[74792],
				type = "FRIENDLY",
				persist = 30,
				unit = "#5#",
				icon = 2,
			},
		},
		announces = {
			fierysay = {
				varname = format(L.alert["Say %s on self"],SN[74562]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[74562]).."!",
			},
			soulsay = {
				varname = format(L.alert["Say %s on self"],SN[74792]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[74792]).."!",
			}
		},
		timers = {
			firecuttercd = {
				{
					"alert","cuttercd",
					--"alert","cutterwarn",
					--"scheduletimer",{"firecutterdur",3},
					"scheduletimer",{"firecuttercd",30},
				},
			},
			firecutterdur = {
				{
					"quash","cutterwarn",
					"alert","cutterdur",
				},
			},
			firedebuffcd = {
				{
					"expect",{"&difficulty&","<=","2"},
					"scheduletimer",{"firedebuffcd",25},
				},
				{
					"expect",{"&difficulty&",">=","3"},
					"scheduletimer",{"firedebuffcd",20},
				},
				{
					"expect",{"<phase>","==","1"},
					"alert","debuffcd",
				},
				{
					"expect",{"<phase>","==","2"},
					"alert",{"debuffcd",text=2},
				},
				{
					"expect",{"<phase>","==","3"},
					"alert",{"debuffcd",text=3},
				},
			},
		},
		events = {
			-- Combustion self
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 75884,
				dstisplayerunit = true,
				execute = {
					{
						"expect",{"#2#","==","nil"},
						"alert","combustionself",
					},
				},
			},
			-- Combustion self applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 75884,
				dstisplayerunit = true,
				execute = {
					{
						"expect",{"#2#","==","nil"},
						"alert","combustionself",
					},
				},
			},
			-- Consumption self
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 75876,
				dstisplayerunit = true,
				execute = {
					{
						"expect",{"#2#","==","nil"},
						"alert","consumptionself",
					},
				},
			},
			-- Consumption self applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 75876,
				dstisplayerunit = true,
				execute = {
					{
						"expect",{"#2#","==","nil"},
						"alert","consumptionself",
					},
				},
			},

			-- Meteor Strike self
			{
				type = "combatevent",
				eventtype = "SPELL_DAMAGE",
				spellname = 75952,
				dstisplayerunit = true,
				execute = {
					{
						"expect",{"#2#","==","nil"},
						"alert","meteorself",
					},
				},
			},
			-- Fiery Combustion
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 74562,
				execute = {
					{
						"scheduletimer",{"firedebuffcd",0},
					},
				},
			},
			-- Fiery Combustion application
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 74562,
				execute = {
					{
						"raidicon","fierymark",
						"alert",{dstself = "fieryself",dstother = "fierydur"},
						"announce",{dstself = "fierysay"},
					},
				},
			},
			-- Fiery Combustion removed
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 74562,
				execute = {
					{
						"batchquash",{"fierydur","fieryself"},
					},
				}
			},
			-- Soul Consumption
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 74792,
				execute = {
					{
						"scheduletimer",{"firedebuffcd",0},
					},
				},
			},
			-- Soul Consumption application
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 74792,
				execute = {
					{
						"raidicon","soulmark",
						"alert",{dstself = "soulself",dstother = "souldur"},
						"announce",{dstself = "soulsay"},
					},
				},
			},
			-- Soul Consumption removed
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 74792,
				execute = {
					{
						"batchquash",{"souldur","soulself"},
					},
				}
			},
			-- Phase 2 start
			{
				type = "event",
				event = "YELL",
				execute = {
					{
						"expect",{"#1#","find",L.chat_ruby["^You will find only suffering"]},
						"alert",{"cuttercd", time = 2},
						"quash","meteorcd",
						"scheduletimer",{"firedebuffcd",0},
						"set",{phase = 2},
					},
				}
			},
			-- Phase 3 start
			{
				type = "event",
				event = "YELL",
				execute = {
					{
						"expect",{"#1#","find",L.chat_ruby["^I am the light and the darkness!"]},
						"set",{phase = 3},
						"alert",{"meteorcd",time=2},
					},
				}
			},
			-- Twilight Cutter
			{
				type = "event",
				event = "EMOTE",
				execute = {
					{
						"expect",{"#1#","find",L.chat_ruby["^The orbiting spheres pulse with"]},
						"alert","cuttercd",
						"alert","cutterwarn",
						"scheduletimer",{"firecutterdur",4.5},
						"scheduletimer",{"firecuttercd",30},
					},
				},
			},
			-- Meteor Strike
			{
				type = "event",
				event = "YELL",
				execute = {
					{
						"expect",{"#1#","find",L.chat_ruby["^The heavens burn!"]},
						"alert","meteorwarn",
						"alert","meteorcd",
					}
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end