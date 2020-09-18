local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- LANATHEL
---------------------------------

do
	local data = {
		version = 26,
		key = "lanathel",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Lana'thel"],
		triggers = {
			scan = 37955, -- Lana'thel
		},
		onactivate = {
			tracerstart = true,
			combatstop = true,
			tracing = {37955}, -- Lana'thel
			defeat = 37955,
		},
		onstart = {
			{
				"expect",{"&difficulty&","==","1"},
				"set",{
					essencetime = 75,
					bloodtime = {127,120, loop = false, type = "series"},
					incitetime = {122,115, loop = false, type = "series"},
				},
			},
			{
				"expect",{"&difficulty&","==","3"},
				"set",{
					essencetime = 75,
					bloodtime = {127,120, loop = false, type = "series"},
					incitetime = {122,115, loop = false, type = "series"},
				},
			},
			{
				"alert","enragecd",
				"alert","bloodboltcd",
				"alert","inciteterrorcd",
				"alert",{"pactcd", time = 15},
				"alert","swarmingshadowcd",
			},
		},
		userdata = {
			bloodtime = {133,100, loop = false, type = "series"},
			incitetime = {128,95, loop = false, type = "series"},
			firedblood = "0",
			essencetime = 60,
			pacttime = {15,30,loop = false, type = "series"},
		},
		alerts = {
			enragecd = {
				varname = L.alert["Enrage"],
				type = "dropdown",
				text = L.alert["Enrage"],
				time = 320,
				flashtime = 10,
				color1 = "RED",
				icon = ST[12317],
			},
			essenceself = {
				varname = format(L.alert["%s on self"],L.alert["Essence"]),
				type = "centerpopup",
				text = format("%s: %s!",L.alert["Essence"],L.alert["YOU"]),
				time = "<essencetime>",
				flashtime = 10,
				color1 = "PURPLE",
				color2 = "MAGENTA",
				icon = ST[71473]
			},
			pactself = {
				varname = format(L.alert["%s on self"],L.alert["Pact"]),
				type = "simple",
				text = format("%s: %s! %s!",L.alert["Pact"],L.alert["YOU"],L.alert["MOVE"]),
				time = 3,
				color1 = "ORANGE",
				sound = "ALERT1",
				flashscreen = true,
				icon = ST[71340],
			},
			pactremovalself = {
				varname = format(L.alert["%s on self"],format(L.alert["%s Removal"],L.alert["Pact"])),
				type = "simple",
				text = format(L.alert["%s Removed"],L.alert["Pact"]).."! "..L.alert["YOU"].."!",
				time = 3,
				color1 = "GOLD",
				sound = "ALERT4",
				flashscreen = true,
				icon = ST[71340],
			},
			bloodboltcd = {
				varname = format(L.alert["%s Cooldown"],SN[71772]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71772]),
				time = "<bloodtime>",
				color1 = "BROWN",
--				sound = "ALERT2",
				flashtime = 10,
				icon = ST[71772],
			},
			bloodboltdur = {
				varname = format(L.alert["%s Duration"],SN[71772]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"],SN[71772]),
				time = 6,
				flashtime = 6,
				color1 = "YELLOW",
--				sound = "ALERT3",
				icon = ST[71772],
			},
			swarmingshadowself = {
				varname = format(L.alert["%s on self"],SN[71265]),
				type = "centerpopup",
				text = format("%s: %s!",SN[71265],L.alert["YOU"]),
				time = 8.5,
				flashtime = 8.5,
				color1 = "BLACK",
				color2 = "GREEN",
				sound = "ALERT3",
				flashscreen = true,
				icon = ST[71265],
			},
			swarmingshadowothers = {
				varname = format(L.alert["%s on others"],SN[71265]),
				type = "centerpopup",
				text = format("%s: #5#!",SN[71265]),
				time = 8.5,
				flashtime = 8.5,
				color1 = "BLACK",
				icon = ST[71265],
			},
			pactcd = {
				varname = format(L.alert["%s Cooldown"],L.alert["Pact"]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],L.alert["Pact"]),
				time = 30,
				flashtime = 5,
				color1 = "BLACK",
				audiocd = 5,
				icon = ST[71340],
			},
			swarmingshadowcd = {
				varname = format(L.alert["%s Cooldown"],SN[71265]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71265]),
				time = 30,
				flashtime = 5,
				color1 = "INDIGO",
				icon = ST[71265],
			},
			inciteterrorcd = {
				varname = format(L.alert["%s Cooldown"],SN[73070]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[73070]),
				time = "<incitetime>",
--				sound = "ALERT6",
				flashtime = 10,
				color1 = "GREY",
				icon = ST[73070],
			},
			bloodthirstself = {
				varname = format(L.alert["%s on self"],SN[70877]),
				type = "centerpopup",
				text = format("%s: %s!",SN[70877],L.alert["YOU"]),
				time = 10,
				flashtime = 10,
				color1 = "WHITE",
				sound = "ALERT4",
				icon = ST[70877],
			},
			frenzywarn = {
				varname = format(L.alert["%s Warning"],SN[70923]),
				type = "simple",
				text = format("%s: #5#",SN[70923]),
				time = 3,
				sound = "ALERT7",
				icon = ST[70923],
			},
		},
		announces = {
			swarmingshadowsay = {
				varname = format(L.alert["Say %s on self"],SN[71265]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[71265]).."!",
			},
		},
		windows = {
			proxwindow = true,
		},
		events = {
			-- Uncontrollable Frenzy
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70923,
				execute = {
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert","frenzywarn",
					},
				},
			},
			-- Frenzied Bloodthirst
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70877,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","bloodthirstself",
					},
				},
			},
			-- Frenzied Bloodthirst removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 70877,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","bloodthirstself",
					},
				},
			},
			-- Swarming Shadows early
			{
				type = "event",
				event = "EMOTE",
				execute = {
					{
						"expect",{"#1#","find",L.chat_citadel["^Shadows amass and swarm"]},
						"quash","swarmingshadowcd",
						"alert","swarmingshadowcd",
						-- Swarming Shadows self
						"expect",{"#5#","==","&playername&"},
						"alert","swarmingshadowself",
					},
					{
						-- Swarming Shadows others
						"expect",{"#1#","find",L.chat_citadel["^Shadows amass and swarm"]},
						"expect",{"#5#","~=","&playername&"},
						"alert","swarmingshadowothers",
					},
				},
			},
			-- Swarming Shadows others removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 71265,
				execute = {
					{
						"expect",{"#4#","~=","&playerguid&"},
						"quash","swarmingshadowothers",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","swarmingshadowself",
						"announce","swarmingshadowsay",
					},
				},
			},
			-- Pact of the Darkfallen
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 71336, -- 10/25
				execute = {
					{
						"quash", "pactcd",
						"alert", "pactcd",
					},
				},
			},
			-- Pact of the Darkfallen applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71340,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","pactself",
					},
				},
			},
			-- Pact of the Darkfallen removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 71340,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","pactremovalself",
					},
				},
			},
			-- Essence of the Blood Queen
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71473,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","essenceself",
					},
				},
			},
			-- Bloodbolt Whirl
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 71772,
				execute = {
					{
						"quash","bloodboltcd",
						"alert","bloodboltdur",
						"expect",{"<firedblood>","==","0"},
						"alert","bloodboltcd",
						"alert","inciteterrorcd",
						"set",{firedblood = 1},
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end
