local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- ICK
---------------------------------

do
	local data = {
		version = 1,
		key = "Ick",
		zone = L.zone["Pit of Saron"],
		category = L.zone["Pit of Saron"],
		name = L.npc_wotlk_party["Ick"],
		triggers = {
			scan = 36476, -- Ick
		},
		onactivate = {
			tracing = 36476,
			tracerstart = true,
			-- tracerstop = false,
			-- combatstop = false,
			defeat = 36476,
			},
		},
		alerts = {
			pursuitdur = {
				varname = format(L.alert["%s Duration"], SN[68987]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"], SN[68987]),
				time = 5,
				color1 = "PURPLE",
				icon = ST[68987],
				},
			pursuitself = {
				varname = format(L.alert["%s on self"], SN[68987]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"], SN[68987]),
				time = 5,
				flashtime = 5,
				sound = "ALERT4",
				color1 = "PURPLE",
				color2 = "CYAN",
				icon = ST[68987],
				flashscreen = true,
				},
			poisonnova = {
				varname = format(L.alert["%s Casting"], SN[68989]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"], SN[68989]),
				time = 5,
				flashtime = 5,
				sound = "ALERT4",
				color1 = "CYAN",
				icon = ST[68989],
				flashscreen = true,
				},
		},
		events = {
			-- Pursuit,
			{
			type = "combatevent",
			eventtype = "SPELL_CAST_START",
			spellname = 68987, --Pursuit
			execute = {
				{
					"expect", {"#4#", "==", "&playerguid&"},
					"alert", "pursuitself",
				},
			},
			execute = {
				{
					"expect", {"#4#", "~=", "&playerguid&"},
					"alert", "pursuitdur",
				},
			},
			},
			-- Poison Nova,
			{
			type = "combatevent",
			eventtype = "SPELL_CAST_START",
			spellname = 68989, --Poison Nova
			execute = {
				{
					"alert", "poisonnova",
				},
			},
			},
		},
	}
DXE:RegisterEncounter(data)
end
