local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Devourer of Souls
---------------------------------

do
	local data = {
		version = 5,
		key = "Devourer",
		zone = L.zone["The Forge of Souls"],
		category = L.zone["WoTLK Party"],
		name = L.npc_wotlk_party["Devourer of Souls"],
		triggers = {
			scan = {36502} -- Devourer of Souls
		},
		onactivate = {
			tracing = {36502}, -- Devourer of Souls
			tracerstart = true,
			tracerstop = true,
			combatstop = true,
			defeat = 36502,
		},
		userdata = {
			mirroredsoultext = "",
		},
		onstart = {
			"alert","mirroredsoulcd",
		},
		alerts = {
			phantomblastwarn = {
				varname = format(L.alert["%s Casting"],SN[68982]),
				text = format(L.alert["%s Casting"],SN[68982]),
				type = "centerpopup",
				time = 2,
				flashtime = 2,
				sound = "ALERT4",
				color1 = "GREEN",
				icon = ST[68982],
				flashscreen = false,
			},
			mirroredsoulwarn = {
				varname = format(L.alert["%s Duration"],SN[69051]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"],SN[69051]),
				type = "centerpopup",
				time = 8,
				flashtime = 8,
				sound = "ALERT2",
				color1 = "MAGENTA",
				color2 = "YELLOW",
				icon = ST[69051],
				flashscreen = true,
			},
			mirroredsoulcd = {
				varname = format(L.alert["%s Cooldown"],SN[69051]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69051]),
				time = 15,
				flashtime = 10,
				color1 = "PURPLE",
				icon = ST[69051],
			},
		},
		raidicons = {
				mirroredsoulmark = {
				varname = SN[69051],
				type = "FRIENDLY",
				persist = 5,
				unit = "&upvalue&",
				icon = 1,
			},
		},
		announces = {
			mirroredsoulsay = {
				varname = format(L.alert["Say %s on self"],SN[69051]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[69051]).."!",
			},
		},
		events = {
			-- Mirrored Soul
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 69051,
				execute = {
					{
						"expect",{"&npcid|#4#&","==","36502"},
						"raidicon","mirroredsoulmark",
						"alert", "mirroredsoulwarn",
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"announce", "mirroredsoulsay",
					},
				},
			},
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellid = 69051,
				execute = {
					{
						"removeraidicon","mirroredsoulmark",
					},
					{
						"expect",{"&npcid|#4#&","~=","36502"},
						"alert", "mirroredsoulcd",
					},
				},
			},
			-- Phantom Blast
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellid = {68982, 70322},
				execute = {
					{
						"alert", "phantomblastwarn",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


