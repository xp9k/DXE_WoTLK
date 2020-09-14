local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Saviana
---------------------------------

do
	local data = {
		version = 5,
		key = "Saviana",
		zone = L.zone["The Ruby Sanctum"],
		category = L.zone["Ruby"],
		name = L.npc_ruby["Saviana"],
		triggers = {
			scan = {39747} -- Saviana
		},
		onactivate = {
			tracing = {39747}, -- Saviana
			tracerstart = true,
			tracerstop = true,
			combatstop = true,
			defeat = 39747,
		},
		onstart = {
			"alert", "enragecd",
			"alert", {"flamebeaconcd", time = 27},
			"alert", {"enragecd", time = 17},
		},
		alerts = {
			enragedur = {
				varname = format(L.alert["%s Duration"],SN[78722]),
				type = "centerpopup",
				text = format("%s: &dstname_or_YOU&",SN[78722]),
				time = 10,
				flashtime = 4,
				sound = "ALERT1",
				color1 = "RED",
				icon = ST[68839],
				flashscreen = false,
			},
			enragecd = {
				varname = format(L.alert["%s Cooldown"],SN[78722]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[78722]),
				time = 17,
				flashtime = 5,
				color1 = "RED",
				icon = ST[74453],
			},
			flamebeaconself = {
				varname = format(L.alert["%s on self"],SN[74453]),
				type = "centerpopup",
				text = format("%s: %s!",SN[74453],L.alert["YOU"]).."!",
				time = 5,
				flashtime = 5,
				color1 = "ORANGE",
				sound = "ALERT3",
				icon = ST[74453],
				flashscreen = true,
			},
			flamebeacondur = {
				varname = format(L.alert["%s Duration"],SN[74453]),
				type = "centerpopup",
				text = format("%s: #5#",SN[74453]),
				time = 5,
				flashtime = 5,
				color1 = "ORANGE",
				icon = ST[74453],
			},	
			flamebeaconcd = {
				varname = format(L.alert["%s Cooldown"],SN[74453]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[74453]),
				time = 50,
				flashtime = 45,
				color1 = "ORANGE",
				icon = ST[74453],
			},			
			conflagrationdur = {
				varname = format(L.alert["%s Duration"],SN[74452]),
				type = "centerpopup",
				text = format("%s: #5#",SN[74452]),
				time = 5,
				flashtime = 5,
				color1 = "ORANGE",
				icon = ST[74452],
			},
		},
		announces = {
			flamebeaconsay = {
				varname = format(L.alert["Say %s on self"],SN[74453]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[74453]).."!",
			},
		},
		events = {
			-- Enrage
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 78722,
				execute = {
					{
						"alert", "enragedur",
						"alert", "enragecd",
					},
				},
			},
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_REMOVED",
				spellid = 78722,
				execute = {
					{
						"quash", "enragedur",
					},
				},
			},
			-- Flame Beacon
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 74453,
				execute = {
					{
						"alert",{dstself = "flamebeaconself",dstother = "flamebeacondur"},
						"announce",{dstself = "flamebeaconsay"},
						"quash", "enragecd",
						"alert", "enragecd",
						"alert", "flamebeaconcd",
					},
				},
			},			
			-- Conflagration
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 74452,
				execute = {
					{
						"alert", "conflagrationdur",						
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end

