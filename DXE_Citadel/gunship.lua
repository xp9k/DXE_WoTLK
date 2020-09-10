local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- GUNSHIP BATTLE
---------------------------------

do
	local faction = UnitFactionGroup("player")

	local prestart_trigger,start_trigger,defeat_msg,portal_msg,add,portal_icon,faction_npc
	if faction == "Alliance" then
		prestart_trigger = L.chat_citadel["^Fire up the engines! We got"]
		start_trigger = L.chat_citadel["^Cowardly dogs"]
		defeat_msg = L.chat_citadel["^Don't say I didn't warn ya"]
		portal_msg = L.chat_citadel["^Reavers, Sergeants, attack"]
		add = L.alert["Reaver"]
		portal_icon = "Interface\\Icons\\achievement_pvp_h_04"
		faction_npc = "36939" -- Saurfang
	elseif faction == "Horde" then
		prestart_trigger = L.chat_citadel["^Rise up, sons and daughters of the"]
		start_trigger = L.chat_citadel["^ALLIANCE GUNSHIP"]
		defeat_msg = L.chat_citadel["^The Alliance falter"]
		portal_msg = L.chat_citadel["^Marines, Sergeants, attack"]
		add = L.alert["Marine"]
		portal_icon = "Interface\\Icons\\achievement_pvp_a_04"
		faction_npc = "36948" -- Muradin
	end

	local data = {
		version = 13,
		key = "gunshipbattle",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Gunship Battle"],
		title = L.npc_citadel["Gunship Battle"],
		triggers = {
			scan = {
				36939, -- Saurfang
				36948, -- Muradin
			},
			yell = {
				prestart_trigger,
				start_trigger,
			},
		},
		onactivate = {
			combatstop = true,
			unittracing = {"boss1","boss2"},
			defeat = defeat_msg,
		},
		userdata = {
			portaltime = {11.5,60,loop = false, type = "series"},
			belowzerotime = {34,45,loop = false, type = "series"},
			battlefurytext = "",
		},
		onstart = {
			{
				"expect",{"#1#","find",prestart_trigger},
				"alert","zerotoonecd",
			},
			{
				"expect",{"#1#","find",start_trigger},
				"alert","portalcd",
				"alert","belowzerocd",
			},
		},
		alerts = {
			zerotoonecd = {
				varname = format(L.alert["%s Timer"],L.alert["Phase One"]),
				type = "centerpopup",
				text = format(L.alert["%s Begins"],L.alert["Phase One"]),
				time = 45,
				flashtime = 20,
				color1 = "MIDGREY",
				icon = ST[3648],
			},
			belowzerocd = {
				varname = format(L.alert["%s Cooldown"],SN[69705]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69705]),
				time = "<belowzerotime>",
				flashtime = 10,
				sound = "ALERT2",
				color1 = "INDIGO",
				icon = ST[69705],
			},
			belowzerowarn = {
				varname = format(L.alert["%s Channel"],SN[69705]),
				type = "centerpopup",
				text = format(L.alert["%s Channel"],SN[69705]),
				time = 900,
				flashtime = 900,
				color1 = "BLUE",
				sound = "ALERT5",
				icon = ST[69705],
			},
			portalcd = {
				varname = format(L.alert["%s Spawns"],add.."/"..L.alert["Sergeant"]),
				type = "dropdown",
				text = format(L.alert["%s Spawns"],add.."/"..L.alert["Sergeant"]),
				time = "<portaltime>",
				flashtime = 10,
				color1 = "GOLD",
				sound = "ALERT1",
				icon = portal_icon,
			},
			battlefurydur = {
				varname = format(L.alert["%s Duration"],SN[69638]),
				type = "centerpopup",
				text = "<battlefurytext>",
				time = 20,
				flashtime = 20,
				color1 = "ORANGE",
				icon = ST[69638],
			},
		},
		events = {
			-- Below Zero
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69705,
				execute = {
					{
						"alert","belowzerowarn",
						"alert","belowzerocd",
					},
				},
			},
			-- Below Zero removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 69705,
				execute = {
					{
						"quash","belowzerowarn",
					},
				},
			},
			-- Portals
			{
				type = "event",
				event = "YELL",
				execute = {
					{
						"expect",{"#1#","find",portal_msg},
						"alert","portalcd",
					},
				},
			},
			-- Battle Fury
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69638,
				execute = {
					{
						"expect",{"&npcid|#4#&","==",faction_npc},
						"set",{battlefurytext = format("%s: #2#!",SN[69638])},
						"alert","battlefurydur",
					},
				},
			},
			-- Battle Fury applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 69638,
				execute = {
					{
						"expect",{"&npcid|#4#&","==",faction_npc},
						"quash","battlefurydur",
						"set",{battlefurytext = format("%s => %s!",SN[69638], format(L.alert["%s Stacks"],"#11#"))},
						"alert","battlefurydur",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end