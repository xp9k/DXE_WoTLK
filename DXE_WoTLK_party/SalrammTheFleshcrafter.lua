local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- SALRAMM THE FLESHCRAFTER
---------------------------------

do
local data = {
	version = 1,
	key = "SalrammTheFleshcrafter",
	zone = L.zone["Old Stratholm"],
	category = L.zone["Old Stratholm"],
	name = L.npc_wotlk_party["Salramm The Fleshcrafter"],
	triggers = {
		scan = 26530, -- Salramm The Fleshcrafter
		yell = L.chat_wotlk_party[""],
		},
	onactivate = {
		tracing = {26530},
--		tracerstart = true,
		tracerstop = true,
		combatstop = true,
		defeat = 26530,
		},
	alerts = {
		cursewarn = {
			varname = format(L.alert["%s Warning"], SN[58845]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[58845]),
			icon = ST[58845],
			},
		stealwarn = {
			varname = format(L.alert["%s Warning"], SN[52709]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[52709]),
			icon = ST[52709],
			},
		ghoulwarn = {
			varname = format(L.alert["%s Warning"], SN[52451]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[52451]),
			icon = ST[52451],
			},
		ghoulcd = {
			varname = format(L.alert["%s Cooldown"], SN[52451]),
			type = "dropdown",
			text = format(L.alert["%s Cooldown"], SN[52451]),
			time = 20,
			color1 = "MAGENTA",
			icon = ST[52451],
			},
		cursedur = {
			varname = format(L.alert["%s Duration"], SN[58845]),
			type = "centerpopup",
			text = format(L.alert["%s Duration"], SN[58845]),
			time = 30,
			color1 = "BLUE",
			icon = ST[58845],
			},
		},
	events = {
		-- Curse,
		{
			type = "combatevent",
			eventtype = "SPELL_AURA_APPLIED",
			spellname = 58845, --Curse
			execute = {
				{
					"alert", "cursewarn",
					"alert", "cursedur",
					},
				},
			},
		-- Steal,
		{
			type = "combatevent",
			eventtype = "SPELL_AURA_APPLIED",
			spellname = 52709, --Steal
			execute = {
				{
					"alert", "stealwarn",
					},
				},
			},
		-- Ghoul,
		{
			type = "combatevent",
			eventtype = "SPELL_SUMMON",
			spellname = 52451, --Ghoul
			execute = {
				{
					"alert", "ghoulwarn",
					"alert", "ghoulcd",
					},
				},
			},
		-- Curse remove,
		{
			type = "combatevent",
			eventtype = "SPELL_AURA_REMOVED",
			spellname = 58845, --Curse remove
			execute = {
				{
					"quash", "cursedur",
					},
				},
			},
		},
	}
DXE:RegisterEncounter(data)
end
