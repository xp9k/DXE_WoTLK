local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- Bronjahm
---------------------------------

do
	local data = {
		version = 1,
		key = "Bronjahm",
		zone = L.chat_5ppl["The Forge of Souls"],
		category = L.chat_5ppl["5ppl"],
		name = L.npc_5ppl["Bronjahm"],
		triggers = {
			yell = L.chat_5ppl["^Finally"],
			scan = {
				36497, -- Bronjahm
			},
		},
		onactivate = {
			tracing = {36497}, -- Bronjahm
			combatstop = true,
			defeat = 36497,
		},
		alerts = {
			corruptsoulwarn = {
				varname = format(L.alert["%s Casting"],L.chat_5ppl["Corrupt Soul"]),
				text = format(L.alert["%s Casting"],L.chat_5ppl["Corrupt Soul"]).." "..L.alert["MOVE"].."!",
				type = "centerpopup",
				time = 4,
				flashtime = 4,
				sound = "ALERT2",
				color1 = "MAGENTA",
				color2 = "YELLOW",
				icon = ST[68839],
				flashscreen = true,
			},
			corruptsoulcd = {
				varname = format(L.alert["%s Cooldown"],SN[68839]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[68839]),
				time = 40,
				flashtime = 10,
				color1 = "PURPLE",
				icon = ST[68839],
			},
		},
		announces = {
			defilesay = {
				varname = format(L.alert["Say %s on self"],SN[68839]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[68839]).."!",
			},
		},
		events = {
			-- Corrupt Soul
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellid = 68839,
				execute = {
					{
						"alert", "corruptsoulwarn",
						"alert", "corruptsoulcd",
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


