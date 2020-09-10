local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- ROTFACE
---------------------------------

do
	local data = {
		version = 14,
		key = "rotface",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Rotface"],
		triggers = {
			scan = {
				36627, -- Rotface
			},
		},
		onactivate = {
			tracerstart = true,
			combatstop = true,
			tracing = {36627},
			defeat = 36627,
		},
		userdata = {
			slimetime = {16,20, loop = false, type = "series"},
			viletime = {24,30, loop = false, type = "series"},
		},
		onstart = {
			{
				"alert","slimespraycd",
				"alert","enragecd",
				"expect",{"&difficulty&",">=","3"},
				"alert","vilegascd",
			},
		},
		alerts = {
			enragecd = {
				varname = L.alert["Enrage"],
				type = "dropdown",
				text = L.alert["Enrage"],
				time = 420,
				time10h = 600,
				flashtime = 10,
				color1 = "RED",
				icon = ST[12317],
			},
			infectionself = {
				varname = format(L.alert["%s on self"],SN[69674]),
				type = "centerpopup",
				text = format("%s: %s!",SN[69674],L.alert["YOU"]),
				time = 12,
				flashtime = 12,
				color1 = "GREEN",
				color2 = "PEACH",
				sound = "ALERT1",
				icon = ST[69674],
				flashscreen = true,
			},
			infectiondur = {
				varname = format(L.alert["%s on others"],SN[69674]),
				type = "centerpopup",
				text = format("%s: #5#!",SN[69674]),
				time = 12,
				flashtime = 12,
				color1 = "TEAL",
				icon = ST[69674],
				tag = "#5#",
			},
			slimespraycastwarn = {
				varname = format(L.alert["%s Casting"],SN[69508]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[69508]),
				time = 1.5,
				flashtime = 1.5,
				sound = "ALERT2",
				color1 = "CYAN",
				icon = ST[69508],
			},
			slimespraychanwarn = {
				varname = format(L.alert["%s Channel"],SN[69508]),
				type = "centerpopup",
				text = format(L.alert["%s Channel"],SN[69508]),
				time = 5,
				flashtime = 5,
				color1 = "CYAN",
				icon = ST[69508],
			},
			slimesprayself = {
				varname = format(L.alert["%s on self"],SN[71213]),
				type = "simple",
				text = format("%s: %s! %s!",SN[71213],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				sound = "ALERT3",
				flashscreen = true,
				icon = ST[71213],
				throttle = 4,
			},
			slimespraycd = {
				varname = format(L.alert["%s Cooldown"],SN[71213]),
				type = "dropdown",
				text = format(L.alert["Next %s"],SN[71213]),
				time = "<slimetime>",
				color1 = "BROWN",
				flashtime = 5,
				icon = ST[71213],
			},
			oozefloodself = {
				varname = format(L.alert["%s on self"],SN[71215]),
				type = "simple",
				text = format("%s: %s! %s!",SN[71215],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				color1 = "BLACK",
				sound = "ALERT3",
				flashscreen = true,
				icon = ST[71215],
				throttle = 3,
			},
			unstableoozewarn = {
				varname = format(L.alert["%s Casting"],SN[69839]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[69839]).."! "..L.alert["MOVE"].."!",
				time = 4,
				flashtime = 4,
				color1 = "MAGENTA",
				sound = "ALERT5",
				flashscreen = true,
				icon = ST[69839],
			},
			unstableoozestackwarn = {
				varname = format(L.alert["%s Stacks"],SN[69558]),
				type = "simple",
				text = format("%s => %s!",SN[69558],format(L.alert["%s Stacks"],"#11#")),
				time = 3,
				color1 = "YELLOW",
				icon = ST[69558],
			},
			vilegascd = {
				varname = format(L.alert["%s Cooldown"],SN[71218]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[71218]),
				time = "<viletime>",
				flashtime = 5,
				color1 = "ORANGE",
				icon = ST[71288],
				throttle = 3,
			},
		},
		timers = {
			fireslimespraychan = {
				{
					"quash","slimespraycastwarn",
					"alert","slimespraychanwarn",
				},
			},
		},
		raidicons = {
			infectionmark = {
				varname = SN[69674],
				type = "MULTIFRIENDLY",
				persist = 12,
				reset = 7,
				unit = "#5#",
				icon = 1,
				total = 4, -- safety
			},
		},
		events = {
			-- Mutated Infection
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 69674,
				execute = {
					{
						"raidicon","infectionmark",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","infectionself",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert","infectiondur",
					},
				},
			},
			-- Mutated Infection removal
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellname = 69674,
				execute = {
					{
						"removeraidicon","#5#",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"quash","infectiondur",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"quash","infectionself",
					},
				},
			},
			-- Slime Spray
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69508,
				execute = {
					{
						"alert","slimespraycd",
						"alert","slimespraycastwarn",
						"scheduletimer",{"fireslimespraychan",1.5},
					},
				},
			},
			-- Slime Spray self
			{
				type = "combatevent",
				eventtype = "SPELL_DAMAGE",
				spellname = 71213,
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","slimesprayself",
					},
				},
			},
			-- Ooze Flood self
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = {
					71215, -- Ooze Flood
					71208, -- Sticky Ooze
				},
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","oozefloodself",
					},
				},
			},
			-- Ooze Flood self applications
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = {
					71588, -- Ooze Flood
					71208, -- Sticky Ooze
				},
				execute = {
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","oozefloodself",
					},
				},
			},
			-- Unstable Ooze Explosion
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 69839,
				execute = {
					{
						"alert","unstableoozewarn",
					},
				},
			},
			-- Unstable Ooze stacks
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED_DOSE",
				spellname = 69558,
				execute = {
					{
						"alert","unstableoozestackwarn",
					},
				},
			},
			-- Vile Gas
			{
				type = "event",
				event = "UNIT_SPELLCAST_SUCCEEDED",
				execute = {
					{
						"expect",{"#2#","==",SN[72287]},
						"alert","vilegascd",
					},
				},
			},
		},
	}


	DXE:RegisterEncounter(data)
end
