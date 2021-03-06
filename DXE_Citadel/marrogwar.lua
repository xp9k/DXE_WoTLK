local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- MARROWGAR
---------------------------------

do
	local data = {
		version = 16,
		key = "marrowgar",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Marrowgar"],
		triggers = {
			scan = {36612}, -- Lord Marrowgar
			yell = L.chat_citadel["^The Scourge will wash over this world"],
		},
		onactivate = {
			combatstop = true,
			tracing = {36612}, -- Lord Marrowgar
			defeat = 36612,
		},
		userdata = {
			bonetime = {45,90,loop = false, type = "series"},
			graveyardtime = {16,18.5,loop = true, type = "series"},
			bonedurtime = 18.5,
		},
		onstart = {
			{
				"expect",{"&difficulty&",">=","3"},
				"set",{bonedurtime = 34},
			},
			{
				"alert","graveyardcd",
				"alert","bonestormcd",
			},
		},
		alerts = {
			bonedachievementdur = {
				varname = format(L.alert["%s Achievement"],L.alert["Boned"]),
				type = "centerpopup",
				text = format(L.alert["%s Achievement"],L.alert["Boned"]),
				time = 8,
				flashtime = 8,
				color1 = "BLACK",
				icon = "Interface\\Icons\\Achievement_Boss_LordMarrowgar",
				throttle = 5,
				enabled = false,
			},
			bonestormwarn = {
				varname = format(L.alert["%s Casting"],SN[69076]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[69076]),
				time = 3,
				flashtime = 3,
				color1 = "GREEN",
--				sound = "ALERT5",
				icon = ST[69076],
			},
			bonestormdur = {
				varname = format(L.alert["%s Duration"],SN[69076]),
				type = "centerpopup",
				text = format(L.alert["%s Ends Soon"],SN[69076]),
				time = "<bonedurtime>",
				flashtime = 15,
				color1 = "BROWN",
				icon = ST[69075],
			},
			bonestormcd = {
				varname = format(L.alert["%s Cooldown"],SN[69076]),
				type = "dropdown",
				text = format(L.alert["Next %s"],SN[69076]),
				time = "<bonetime>",
				flashtime = 10,
				color1 = "BLUE",
--				sound = "ALERT1",
				icon = ST[69076],
			},
			coldflameself = {
				varname = format(L.alert["%s on self"],SN[70823]),
				type = "simple",
				text = format("%s: %s! %s!",SN[70823],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				color1 = "INDIGO",
				sound = "ALERT1",
				icon = ST[70823],
				flashscreen = true,
			},
			graveyardwarn = {
				varname = format(L.alert["%s Casting"],SN[70826]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[70826]),
				time = 3,
				flashtime = 3,
				color1 = "GREY",
--				sound = "ALERT3",
				icon = ST[70826],
			},
			graveyardcd = {
				varname = format(L.alert["%s Cooldown"],SN[70826]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[70826]),
				time = "<graveyardtime>",
				flashtime = 7,
				color1 = "PURPLE",
				icon = ST[70826],
			},
			impalewarn = {
				varname = format(L.alert["%s Warning"],SN[69062]),
				type = "simple",
				text = format("%s: &debuffednames|"..SN[69062].."&",SN[69062]),
				time = 5,
				flashtime = 5,
				color1 = "ORANGE",
				icon = ST[69062],
			},
		},
		arrows = {
			impalearrow = {
				varname = SN[69062],
				unit = "#2#",
				persist = 15,
				action = "TOWARD",
				msg = L.alert["KILL IT"],
				spell = SN[69062],
			},
		},
		raidicons = {
			impalemark = {
				varname = SN[69062],
				type = "MULTIFRIENDLY",
				persist = 15,
				reset = 3,
				unit = "#2#",
				icon = 1,
				total = 3,
			},
		},
		events = {
			-- Bone Storm cast
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69076,
				execute = {
					{
						"alert","bonestormwarn",
						"expect",{"&difficulty&","<=","2"},
						"quash","graveyardcd",
					},
				},
			},
			-- Bone Storm duration and cooldown
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69076,
				execute = {
					{
						"quash","bonestormcd",
						"alert","bonestormdur",
						"alert","bonestormcd",
					},
				},
			},
			-- Bone Storm removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 69076,
				execute = {
					{
						"quash","bonestormdur",
					},
				},
			},
			-- Coldflame self
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 70823,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","coldflameself",
					},
				},
			},
			-- Bone Spike Graveyard
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 70826,
				execute = {
					{
						"alert","graveyardwarn",
						"alert","graveyardcd",
					},
				},
			},
			-- Impale
			{
				type = "combatevent",
				eventtype = "SPELL_SUMMON",
				spellname = 69062,
				execute = {
					{
						"alert","bonedachievementdur",
						"raidicon","impalemark",
						"expect",{"#1#","~=","&playerguid&"},
						"arrow","impalearrow",
					},
					{
						"schedulealert", {"impalewarn", 0.2},
					},
				},
			},
			-- Impale removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 69065, -- different spellid from SPELL_SUMMON
				execute = {
					{
						"expect",{"#4#","~=","&playerguid&"},
						"removeraidicon","#5#",
						"removearrow","#5#",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end
