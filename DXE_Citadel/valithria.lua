local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- VALITHRIA
---------------------------------

do
	local data = {
		version = 13,
		key = "valithria",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Valithria"],
		triggers = {
			scan = 36789,
			yell = L.chat_citadel["^Heroes, lend me your aid"],
		},
		onactivate = {
			combatstop = true,
			tracing = {36789},
			defeat = L.chat_citadel["^I AM RENEWED!"],
		},
		onstart = {
			{
				"alert","enragecd",
				"alert","portalcd",
				--"alert","blazingskeletoncd",
				--"scheduletimer",{"fireblazing",35},
			},
		},
		userdata = {
			portaltime = {33,45, loop = false, type = "series"},
			corrosiontext = "",
			blazingtime = {35,60, loop = false, type = "series"}, -- unknown
			nightmaretext = "";
		},
		timers = {
			firelaywaste = {
				{
					"quash","laywastewarn",
					"alert","laywastedur",
				}
			},
			fireportaldur = {
				{
					"quash","portalwarn",
					"alert","portaldur",
				}
			},
			fireblazing = {
				{
					"alert","blazingskeletoncd",
					"scheduletimer",{"fireblazing",60},
				},
			},
		},
		alerts = {
			enragecd = {
				varname = L.alert["Soft Enrage"],
				type = "dropdown",
				text = L.alert["Soft Enrage"],
				time = 420,
				flashtime = 10,
				color1 = "RED",
				icon = ST[12317],
			},
			blazingskeletoncd = {
				varname = format(L.alert["%s Spawns"],L.npc_citadel["Blazing Skeleton"]),
				type = "dropdown",
				text = format(L.alert["%s Spawns"],L.npc_citadel["Blazing Skeleton"]),
				time = 35,
				flashtime = 10,
				color1 = "YELLOW",
				icon = ST[49264],
			},
			portalcd = {
				varname = format(L.alert["%s Cooldown"],L.alert["Portals"]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],L.alert["Portals"]),
				time = "<portaltime>",
				flashtime = 10,
--				sound = "ALERT4",
				color1 = "GREEN",
				icon = ST[57676],
			},
			portalwarn = {
				varname = format(L.alert["%s Warning"],L.alert["Portals"]),
				type = "centerpopup",
				text = format(L.alert["%s Soon"],L.alert["Portals"]).."!",
				time = 15,
--				sound = "ALERT4",
				color1 = "GREEN",
				icon = ST[57676],
			},
			portaldur = {
				varname =  format(L.alert["%s Duration"],L.alert["Portals"]),
				type = "centerpopup",
				text =  format(L.alert["%s Duration"],L.alert["Portals"]),
				time = 10,
--				sound = "ALERT7",
				color1 = "GREEN",
				icon = ST[57676],
			},
			manavoidself = {
				varname = format(L.alert["%s on self"],SN[71743]),
				type = "simple",
				text = format("%s: %s! %s!",SN[71743],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				sound = "ALERT3",
				color1 = "PURPLE",
				flashscreen = true,
				throttle = 2,
				icon = ST[71743],
			},
			laywastewarn = {
				varname = format(L.alert["%s Warning"],SN[69325]),
				type =  "centerpopup",
				text = format(L.alert["%s Soon"],SN[69325]),
				time = 2,
				sound = "ALERT4",
				color1 = "ORANGE",
				icon = ST[69325],
			},
			laywastedur = {
				varname = format(L.alert["%s Duration"],SN[69325]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"],SN[69325]),
				time = 12,
				flashtime = 12,
				color1 = "ORANGE",
				icon = ST[69325],
			},
			gutspraywarn = {
				varname = format(L.alert["%s Warning"],SN[70633]),
				type = "simple",
				text = format(L.alert["%s Warning"],SN[70633]),
				time = 3,
				sound = "ALERT4",
				icon = ST[70633],
			},
			corrosionself = {
				varname = format(L.alert["%s on self"],SN[70751]),
				type = "centerpopup",
				text = "<corrosiontext>",
				time = 6,
				flashtime = 6,
				sound = "ALERT4",
				color1 = "CYAN",
				icon = ST[70751],
			},
			nightmaredur = {
				varname = format(L.alert["%s Duration"],SN[71940]),
				type = "centerpopup",
				text = "<nightmaretext>",
				time = 40,
				color1 = "GREY",
				icon = ST[71940],
			},
		},
		events = {
			{
				type = "event",
				event = "YELL",
				execute = {
					{
						"expect",{"#1#","find",L.chat_citadel["^I have opened a portal into the Dream"]},
						"alert","portalwarn",
						"alert","portalcd",
						"scheduletimer",{"fireportaldur",15},
					},
				},
			},
			-- Twisted Nightmare
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 71941, -- there seem to be two spellids, don't use 71940
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{nightmaretext = format("%s: %s!",SN[71941],L.alert["YOU"])},
						"alert","nightmaredur",
					},
				}
			},
			-- Twisted Nightmare stacks
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellid = 71941, -- there seem to be two spellids, don't use 71940
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{nightmaretext = format("%s: %s! %s",SN[71941],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"quash","nightmaredur",
						"alert","nightmaredur",
					},
				}
			},
			-- Twisted Nightmare removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellid = 71941, -- there seem to be two spellids, don't use 71940
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","nightmaredur",
					},
				}
			},
			-- Mana Void (hit)
			{
				type = "combatevent",
				eventtype = "SPELL_DAMAGE",
				spellname = 71086,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","manavoidself",
					},
				},
			},
			-- Mana Void (miss)
			{
				type = "combatevent",
				eventtype = "SPELL_MISSED",
				spellname = 71086,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","manavoidself",
					},
				},
			},
			-- Lay Waste
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69325,
				execute = {
					{
						"alert","laywastewarn",
						"scheduletimer",{"firelaywaste",2},
					},
				},
			},
			-- Lay Waste removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 69325,
				execute = {
					{
						"quash","laywastewarn",
						"canceltimer","firelaywaste",
						"quash","laywastedur",
					},
				},
			},
			-- Gut Spray
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 70633,
				execute = {
					{
						"alert","gutspraywarn",
					}
				},
			},
			-- Corrosion
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70751,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"set",{corrosiontext = format("%s: %s!",SN[70751],L.alert["YOU"])},
						"alert","corrosionself",
					},
				},
			},
			-- Corrosion applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 70751,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","corrosionself",
						"set",{corrosiontext = format("%s: %s! %s!",SN[70751],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
						"alert","corrosionself",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end
