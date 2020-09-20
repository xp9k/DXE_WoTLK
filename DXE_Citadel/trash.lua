local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- TRASH
---------------------------------


do
	local data = {
		version = 3,
		key = "icctrash",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = format(L.alert["%s (T)"],L.npc_citadel["Deathbound Ward"]),
		triggers = {
			scan = {
				37007, -- Deathbound Ward
			},
		},
		onactivate = {
			tracing = {37007}, -- Deathbound Ward
			tracerstart = true,
			combatstop = true,
		},
		alerts = {
			disruptshoutwarn = {
				varname = format(L.alert["%s Casting"],SN[71022]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[71022]),
				time = 3,
				flashtime = 3,
				color1 = "ORANGE",
				sound = "ALERT1",
				flashscreen = true,
				icon = ST[71022],
			},
		},
		events = {
			-- Disrupting Shout
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellid = 71022, -- 10/25
				execute = {
					{
						"alert","disruptshoutwarn"
					},
				}
			}
		},
	}

	DXE:RegisterEncounter(data)
end

do
	local decimate_event = {
		type = "combatevent",
		eventtype = "SPELL_CAST_START",
		spellid = 71123, -- 10/25
		execute = {
			{
				"alert","decimatewarn"
			},
		}
	}

	local mortal_wound_event = {
		type = "combatevent",
		eventtype = "SPELL_AURA_APPLIED",
		spellid = 71127,
		execute = {
			{
				"expect",{"#4#","==","&playerguid&"},
				"set",{mortaltext = format("%s: %s!",SN[71127],L.alert["YOU"])},
				"alert","mortalwarn",
			},
			{
				"expect",{"#4#","~=","&playerguid&"},
				"set",{mortaltext = format("%s: #5#!",SN[71127])},
				"alert","mortalwarn",
			},
		},
	}

	local mortal_wound_dose_event = {
		type = "combatevent",
		eventtype = "SPELL_AURA_APPLIED_DOSE",
		spellid = 71127,
		execute = {
			{
				"expect",{"#4#","==","&playerguid&"},
				"set",{mortaltext = format("%s: %s! %s!",SN[71127],L.alert["YOU"],format(L.alert["%s Stacks"],"#11#"))},
				"alert","mortalwarn",
			},
			{
				"expect",{"#4#","~=","&playerguid&"},
				"set",{mortaltext = format("%s: #5#! %s!",SN[71127],format(L.alert["%s Stacks"],"#11#")) },
				"alert","mortalwarn",
			},
		},
	}

	local decimatewarn = {
		varname = format(L.alert["%s Casting"],SN[71123]),
		type = "centerpopup",
		text = format(L.alert["%s Casting"],SN[71123]),
		time = 3,
		flashtime = 3,
		color1 = "PURPLE",
		sound = "ALERT4",
		flashscreen = true,
		icon = ST[71123],
	}
	local mortalwarn = {
		varname = format(L.alert["%s Warning"],SN[71127]),
		type = "simple",
		text = "<mortaltext>",
		time = 3,
		color1 = "RED",
		icon = ST[71127],
	}

	do
		local data = {
			version = 5,
			key = "icctrashtwo",
			zone = L.zone["Icecrown Citadel"],
			category = L.zone["Citadel"],
			name = format(L.alert["%s (T)"],L.npc_citadel["Stinky"]),
			triggers = {
				scan = {
					37025, -- Stinky
				},
			},
			onactivate = {
				tracing = {
					37025, -- Stinky
				},
				tracerstart = true,
				combatstop = true,
				defeat = 37025, -- Stinky
			},
			userdata = {
				mortaltext = "",
			},
			alerts = {
				decimatewarn = decimatewarn,
				mortalwarn = mortalwarn,
			},
			events = {
				-- Decimate
				decimate_event,
				-- Mortal Wound
				mortal_wound_event,
				-- Mortal Wounds applications
				mortal_wound_dose_event,
			},
		}

		DXE:RegisterEncounter(data)
	end

	do
		local data = {
			version = 3,
			key = "icctrashthree",
			zone = L.zone["Icecrown Citadel"],
			category = L.zone["Citadel"],
			name = format(L.alert["%s (T)"],L.npc_citadel["Precious"]),
			triggers = {
				scan = {
					37217, -- Precious
				},
			},
			onactivate = {
				tracing = {
					37217, -- Precious
				},
				tracerstart = true,
				combatstop = true,
				defeat = 37217, -- Precious
			},
			userdata = {
				mortaltext = "",
				awakentime = {28,20,loop = false, type = "series"},
			},
			alerts = {
				decimatewarn = decimatewarn,
				mortalwarn = mortalwarn,
				awakencd = {
					varname = format(L.alert["%s Cooldown"],SN[71159]),
					type = "dropdown",
					text = format(L.alert["%s Cooldown"],SN[71159]),
					time = "<awakentime>",
					flashtime = 10,
					color1 = "GREY",
					icon = ST[71159],
				}
			},
			events = {
				-- Decimate
				decimate_event,
				-- Mortal Wound
				mortal_wound_event,
				-- Mortal Wounds applications
				mortal_wound_dose_event,
				-- Awaken Plagued Zombie
				{
					type = "event",
					event = "EMOTE",
					execute = {
						{
							"expect",{"#2#","==",L.npc_citadel["Precious"]},
							"alert","awakencd",
						},
					},
				},
			},
		}

		DXE:RegisterEncounter(data)
	end
end

do
	local data = {
		version = 1,
		key = "icctrashfour",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = format(L.alert["%s (T)"],L.npc_citadel["Deathspeaker High Priest"]),
		triggers = {
			scan = {
				36829, -- Deathspeaker High Priest 
			},
		},
		onactivate = {
			tracing = {36829}, -- Deathspeaker High Priest 
			tracerstart = true,
			combatstop = true,
		},
		alerts = {
			darkreckoningwarn = {
				varname = format(L.alert["%s on others"],SN[69483]),
				type = "simple",
				text = format("%s: #5#!",SN[69483]),
				time = 8,
				color1 = "PURPLE",
				sound = "ALERT2",
				icon = ST[69483],
			},
			darkreckoningself = {
				varname = format(L.alert["%s on self"],SN[69483]),
				type = "simple",
				text = format("%s: %s! %s!",SN[69483],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 8,
				color1 = "PURPLE",
				sound = "ALERT3",
				icon = ST[69483],
				flashscreen = true,
			},
		},
		raidicons = {
			darkreckoningmark = {
				varname = SN[69483],
				type = "FRIENDLY",
				persist = 8,
				unit = "#5#",
				icon = 1,
			},
		},
		events = {
			-- Dark Reckoning 
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 69483, -- 10/25
				execute = {
					{
						"raidicon","darkreckoningmark",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"alert","darkreckoningself",
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"alert","darkreckoningwarn",
					},
				}
			}
		},
	}

	DXE:RegisterEncounter(data)
end
