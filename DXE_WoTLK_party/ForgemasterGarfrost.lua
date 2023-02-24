local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- FORGEMASTER GARFROST
---------------------------------

do
local data = {
	version = 300,
	key = "ForgemasterGarfrost",
	zone = L.zone["Pit of Saron"],
	category = L.zone["Pit of Saron"],
	name = L.npc_wotlk_party["Forgemaster Garfrost"],
	triggers = {
		scan = 36494, -- Forgemaster Garfrost
	},
	onactivate = {
		tracing = {36494},
		tracerstart = true,
		tracerstop = true,
		combatstop = true,
		defeat = 36494,
		},
	alerts = {
		forgeweaponwarn = {
			varname = format(L.alert["%s Warning"], SN[70335]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[70335]),
			icon = ST[70335],
			},
		deepfreezewarn = {
			varname = format(L.alert["%s Warning"], SN[70384]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[70384]),
			icon = ST[70384],
			},
		saroniterockwarn = {
			varname = format(L.alert["%s Warning"], SN[70851]),
			type = "simple",
			text = format(L.alert["%s Warning"], SN[70851]),
			icon = ST[70851],
			},
		},
	events = {
		-- Forge Weapon,
		{
			type = "combatevent",
			eventtype = "SPELL_AURA_APPLIED",
			spellname = 68785, --Forge Weapon
			execute = {
				{
					"alert", "forgeweaponwarn",
					},
				},
			},
		-- Deep Freeze,
		{
			type = "combatevent",
			eventtype = "SPELL_AURA_APPLIED",
			spellname = 70381, --Deep Freeze
			execute = {
				{
					"alert", "deepfreezewarn",
					},
				},
			},
		-- Saronite Rock,
		{
			type = "combatevent",
			eventtype = "SPELL_CREATE",
			spellname = 68789, --Saronite Rock
			execute = {
				{
					"alert", "saroniterockwarn",
					},
				},
			},
		},
	}
DXE:RegisterEncounter(data)
end
