local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- IONAR
---------------------------------

do
	local data = {
		version = 1,
		key = "Ionar",
		zone = L.zone["Halls of Lightning"],
		category = L.zone["Halls of Lightning"],
		name = L.npc_wotlk_party["Ionar"],
		triggers = {
			scan = 28546, -- Ionar
		},
		onactivate = {
			tracing = {28546},
			tracerstart = true,
			tracerstop = false,
			combatstop = false,
			defeat = 28546,
		},
		alerts = {
			overloaddur = {
				varname = format(L.alert["%s Duration"], SN[52658]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"], SN[52658]),
				time = 10,
				color1 = "BLUE",
				icon = ST[52658],
				},
			dispersewarn = {
				varname = format(L.alert["%s Warning"], SN[52770]),
				type = "simple",
				text = format(L.alert["%s Warning"], SN[52770]),
				time = 10,
				color1 = "CYAN",
				icon = ST[52770],
				},
		},
		events = {
			-- Disperse,
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 52770, --Disperse
				execute = {
					{
						"alert", "dispersewarn",
					},
				},
			},
			-- Overload,
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 52658, --Overload
				execute = {
					{
						"alert", "overloaddur",
					},
				},
			},
		},
	}
	DXE:RegisterEncounter(data)
end
