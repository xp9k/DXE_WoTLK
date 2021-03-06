-------------------------------------------------------------------------------
-- flump Declaration
--

local addon,L = DXE,DXE.L
local EDB = addon.EDB
local flump = CreateFrame("Frame")
local module = addon:NewModule("Flump")

addon.plugins.Flump = module

flump.name = "Flump"

-------------------------------------------------------------------------------
-- Locals
--

--local L = LibStub("AceLocale-3.0"):GetLocale("DXE")

local db = addon.db
local pfl

local OUTPUT = "SELF"			-- Which channel should the announcements be sent to?
local MIN_TANK_HP = 55000		-- How much health must a player have to be considered a tank?
local MIN_HEALER_MANA = 20000	-- How much mana must a player have to be considered a healer?
local DIVINE_PLEA = true		-- Announce when (holy) Paladins cast Divine Plea? (-50% healing)

local status = "|cff39d7e5Flump: %s|r"
local spellstatus = "%s %s!"

-- local bot	 = "%s%s ставит %s!"
-- local used	 = "%s%s использовал(а) %s!"
-- local sw	 = "%s заканчивается на %s%s!"
-- local cast	 = "%s%s применяет %s на %s%s!"
-- local fade	 = "На %s%s заканчивается %s от %s%s!"
-- local feast  = "%s%s готовит %s!"
-- local gs	 = "%s%s's %s прокнул: %d отлечено!"
-- local ad	 = "%s%s's %s consumed!"
-- local res	 = "%s%s применяет %s на %s%s!"
-- local portal = "%s%s открыл(а) %s!"
-- local create = "%s%s создал(а) %s!"
-- local dispel = "%s%s's %s failed to dispel %s%s's %s!"
-- local ss	 = "%s умер с %s!"
-- local miscellaneous = "%s применяет %s"

local sacrifice  = {}
local soulstones = {}
local ad_heal	 = false

local HEROISM	= UnitFactionGroup("player") == "Horde" and 2825 or 32182	-- Horde = "Bloodlust" / Alliance = "Heroism"
local REBIRTH 	= GetSpellInfo(20484)										-- "Rebirth"
local HOP 		= GetSpellInfo(1022)										-- "Hand of Protection"
local SOULSTONE = GetSpellInfo(20707)										-- "Soulstone Resurrection"
local CABLES	= GetSpellInfo(54732)										-- "Defibrillate

-- Upvalues
local UnitInRaid, UnitAffectingCombat = UnitInRaid, UnitAffectingCombat
local UnitHealthMax, UnitManaMax = UnitHealthMax, UnitManaMax
local GetSpellLink, UnitAffectingCombat, format = GetSpellLink, UnitAffectingCombat, string.format

-- http://www.wowhead.com/?search=portal#abilities
local port = {
	-- Mage
	[53142] = true, -- Portal: Dalaran        (Alliance/Horde)
	[11419] = true, -- Portal: Darnassus      (Alliance)
	[32266] = true, -- Portal: Exodar         (Alliance)
	[11416] = true, -- Portal: Ironforge      (Alliance)
	[11417] = true, -- Portal: Orgrimmar      (Horde)
	[33691] = true, -- Portal: Shattrath      (Alliance)
	[35717] = true, -- Portal: Shattrath      (Horde)
	[32267] = true, -- Portal: Silvermoon     (Horde)
	[49361] = true, -- Portal: Stonard        (Horde)
	[10059] = true, -- Portal: Stormwind      (Alliance)
	[49360] = true, -- Portal: Theramore      (Alliance)
	[11420] = true, -- Portal: Thunder Bluff  (Horde)
	[11418] = true, -- Portal: Undercity      (Horde)
}

local rituals = {
	-- Mage
	[58659] = true, -- Ritual of Refreshment
	-- Warlock
	[58887] = true, -- Ritual of Souls
	[698]	= true,	-- Ritual of Summoning
}

local spells = {
	-- Paladin
	[48788] = true, -- Lay on Hands
	[10278] = true, -- Длань защиты
	[6940] = true,	-- Длань жертвенности
	[1044] = true,	-- Длань свободы
	[1038] = true,	-- Длань спасения
	[19752] = true,	-- Божественное вмешательство
	-- Priest
	[47788] = true, -- Guardian Spirit
	[33206] = true, -- Pain Suppression
	[10060] = true,	-- Придание сил
	--Druid
	[29166] = true, -- Озарение
	--DK
	[49016] = true, -- Истерия
	--Hunter
	[20736] = true, -- Отвлекающий выстрел
	[34477] = true, -- Перенаправление
	--Rogue
	[57934] = true, -- Маленькие хитрости
}

local bots = {
	-- Engineering
	[22700] = true,	-- Field Repair Bot 74A
	[44389] = true,	-- Field Repair Bot 110G
	[67826] = true,	-- Jeeves
	[54710] = true,	-- MOLL-E
	[54711] = true,	-- Scrapbot
}

local use = {
	-- Death Knight
	[48707] = true,	-- Anti-Magic Shell
	[48792] = true,	-- Icebound Fortitude
	[55233] = true,	-- Vampiric Blood
	-- Druid
	[22812] = true,	-- Barkskin
	[22842] = true,	-- Frenzied Regeneration
	[61336] = true,	-- Survival Instincts
	-- Warrior
	[12975] = true,	-- Last Stand [Gain]
	[871] 	= true,	-- Shield Wall
	-- Paladin
	[498] 	= true, -- Divine Protection
	[642]	= true, -- Бабл
	-- Mage
	[45438] = true,	-- Ледяная глыба
}

local misc = {
	[42650] = true, -- Войско мертвых
	[48447] = true, -- Спокойствие
}

local bonus = {
	-- Death Knight
	[70654] = true, -- Blood Armor [4P T10]
	-- Druid
	[70725] = true, -- Enraged Defense [4P T10]
}

local trinkets = {
	-- Trinkets
	[71638] = 50364, -- Sindragosa's claw Heroic
	[71635] = 50361, -- Sindragosa's claw
	[71586] = 50356, -- Key
	[75495] = 54589, -- Хиловская чешка гер
	[75490] = 54573, -- Хиловская чешка
	[67699] = UnitFactionGroup("player") == "Horde" and 47290 or 47080, -- Жизненная сила владыки мира
	[67753] = UnitFactionGroup("player") == "Horde" and 47451 or 47088, -- Жизненная сила владыки мира Her.
	}

local trinkets_opt = {
	-- Trinkets
	[71638] = true, -- Sindragosa's claw Heroic
	[71635] = true, -- Sindragosa's claw
	[71586] = true, -- Key
	[75495] = true, -- Хиловская чешка гер
	[75490] = true, -- Хиловская чешка
	[67699] = true, -- Жизненная сила владыки мира
	[67753] = true, -- Жизненная сила владыки мира Her.
	}

local feasts = {
	[57426] = true, -- Fish Feast
	[57301] = true, -- Great Feast
	[66476] = true, -- Bountiful Feast
}

local special = {
	-- Paladin
	[31821] = true, -- Aura Mastery
	-- Priest
	[64843] = true, -- Divine Hymn
	[64901] = true, -- Гимн надежды
}

local toys = {
	[61031] = true, -- Toy Train Set
	[49844] = true, -- Пульт Худовара
	[48933] = true, -- Червоточина
}

local dispels = {
	[475] = true, -- Снятие проклятия (Маг)
	[526] = true, -- Оздоровление
	[528] = true, -- Излечение болезни (Прист)
	[552] = true, -- Устранение болезни (Прист)
	[988] = true, -- Рассеивание заклинаний
	[2782] = true, -- Снятие проклятия (Друид)
	[4987] = true, -- Очищение (Паладин)
	[5938] = true, -- Отравляющий укол (Рога)
	[19801] = true, -- Усмиряющий выстрел (Хант)
	[32375] = true, -- Массовое рассеивание (Прист)
	[51886] = true, -- Очищение духа (Шам)
}

local fails = {
	-- The Lich King
	["Necrotic Plague"] = true,
	-- Shambling Horror
	["Enrage"] = "Shambling Horror",
}

local chats = {
	"NONE",
	"SELF",
	"PARTY",
	"RAID",
}

local chats_loc = {
	L.Plugins["NONE"],
	L.Plugins["SELF"],
	L.Plugins["PARTY"],
	L.Plugins["RAID"],
}

local plugins_group = {}

local defaults = {
		Enabled = true,
		Chat = 2,
		OnlyTanks = false,
		InCombat = false,
}

-- local Options = {
			-- Enabled = true,
			-- Chat = 0,
			-- OnlyTanks = false,
			-- InCombat = false
			-- }

-------------------------------------------------------------------------------
-- Initialization
--

--for i, j in pairs(port) do
--	print(GetSpellInfo(i), j)
--end

local function send(msg)
	if OUTPUT == "NONE" then return end
	if OUTPUT == "SELF" then
		print(msg)
	else
		SendChatMessage(msg, OUTPUT)
	end
end

local function isFemale(unit)
	if UnitSex(unit) and UnitSex(unit)==3 then return true
	else return false
	end
end

local function icon(name)
	local n = GetRaidTargetIndex(name)
	return n and format("{rt%d}", n) or ""
end

function IsTank(srcName)
	return not (pfl.OnlyTanks and not (UnitHealthMax(srcName) >= MIN_TANK_HP) )
--	return  UnitHealthMax(srcName) >= MIN_TANK_HP or not Options.OnlyTanks
end

function flump:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, school, ...)

	if not pfl.Enabled then return end

	-- If the caster isn't in the raid group
	if not (UnitInRaid(srcName) or UnitInParty(srcName))then return end

	-- [X] died with a Soulstone!
	if UnitInRaid(destName) then -- If the target isn't in the raid group
		if spellName == SOULSTONE and event == "SPELL_AURA_REMOVED" then
			if not soulstones[destName] then soulstones[destName] = {} end
			soulstones[destName].time = GetTime()
		elseif spellID == 27827 and event == "SPELL_AURA_APPLIED" then
			soulstones[destName] = {}
			soulstones[destName].SoR = true -- Workaround for Spirit of Redemption issue
		elseif event == "UNIT_DIED" and soulstones[destName] and not UnitIsFeignDeath(destName) then
			if not soulstones[destName].SoR and (GetTime() - soulstones[destName].time) < 2 then
				if isFemale(destName) then
					send(L.Plugins["ss_fem"]:format(destName, GetSpellLink(6203)))
				else
					send(L.Plugins["ss"]:format(destName, GetSpellLink(6203)))
				end
				SendChatMessage(L.Plugins["ss"]:format(destName, GetSpellLink(6203)), "RAID_WARNING")
			end
			soulstones[destName] = nil
		end
	end

	if event == "SPELL_CAST_SUCCESS" then
		if spellID == HEROISM then
			if isFemale(srcName) then
				send(L.Plugins["used_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used [Y] -- Heroism/Bloodlust
			else
				send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
		elseif pfl.BotsEnable and bots[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["bot_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used a [Y] -- Bots
			else
				send(L.Plugins["bot"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
		elseif pfl.RitualsEnable and rituals[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["create_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] is casting a [Z] -- Rituals
			else
				send(L.Plugins["create"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
		elseif pfl.MiscEnable and misc[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["miscellaneous_fem"]:format(srcName, GetSpellLink(spellID))) --Misc
			else
				send(L.Plugins["miscellaneous"]:format(srcName, GetSpellLink(spellID)))
			end
		end

	elseif event == "SPELL_AURA_APPLIED" then -- Check name instead of ID to save checking all ranks
		if spellName == SOULSTONE then
			local _, class = UnitClass(srcName)
			if class == "WARLOCK" then -- Workaround for Spirit of Redemption issue
				if isFemale(srcName) then
					send(L.Plugins["cast_fem"]:format(icon(srcName), srcName, GetSpellLink(6203), icon(destName), destName)) -- [X] cast [Y] on [Z] -- Soulstone
				else
					send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(6203), icon(destName), destName))
				end
			end
		end

	elseif event == "SPELL_CREATE" then
		if pfl.PortEnable and port[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["portal_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] opened a [Z] -- Portals
			else
				send(L.Plugins["portal"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
		elseif toys[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["bot_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used a [Z]
			else
				send(L.Plugins["bot"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
		end

	elseif event == "SPELL_CAST_START" then
		if pfl.FeastsEnable and feasts[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["feast_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] prepares a [Z] -- Feasts
			else
				send(L.Plugins["feast"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
		end

	elseif event == "SPELL_RESURRECT" then
		if spellName == REBIRTH then -- Check name instead of ID to save checking all ranks
			if isFemale(srcName) then
				send(L.Plugins["cast_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X] cast [Y] on [Z] -- Rebirth
			else
				send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			end
		elseif spellName == CABLES then
			if isFemale(srcName) then
				send(L.Plugins["res_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			else
				send(L.Plugins["res"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			end

	elseif event == "SPELL_DISPEL_FAILED" then
		local extraID, extraName = ...
		local target = fails[extraName]
		if target or destName == target then
			if isFemale(srcName) then
				send(L.Plugins["dispel_failed_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName, GetSpellLink(extraID))) -- [W]'s [X] failed to dispel [Y]'s [Z]
			else
				send(L.Plugins["dispel_failed"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName, GetSpellLink(extraID)))
			end
		end
	end

	elseif event == "SPELL_DISPEL" then
		if pfl.DispelsEnable and dispels[spellID] then
			if isFemale(srcName) then
				send(L.Plugins["dispels_fem"]:format(icon(srcName), srcName, GetSpellLink(extraID), icon(destName), destName)) -- [W]'s [X] failed to dispel [Y]'s [Z]
			else
				send(L.Plugins["dispels"]:format(icon(srcName), srcName, GetSpellLink(extraID), icon(destName), destName))
			end
		end
	end

	if not (pfl.InCombat and not UnitAffectingCombat(srcName)) then -- If the caster is in combat
		if event == "SPELL_CAST_SUCCESS" then
			if pfl.SpellsEnable and spells[spellID] then
				if isFemale(srcName) then
					send(L.Plugins["cast_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X] cast [Y] on [Z]
				else
					send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				end
			elseif spellID == 19752 then -- Don't want to announce when it fades, so
				if isFemale(srcName) then
					send(L.Plugins["cast_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- Divine Intervention
				else
					send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				end
			elseif pfl.UseEnable and use[spellID] and IsTank(srcName) then
				if isFemale(srcName) then
					send(L.Plugins["used_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used [Y]
				else
					send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
				end
			elseif spellID == 64205 and IsTank(srcName) then  -- Workaround for Divine Sacrifice issue
				if isFemale(srcName) then
					send(L.Plugins["used_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used Divine Sacrifice
				else
					send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
				end
				sacrifice[srcGUID] = true
			elseif pfl.SpecialEnable and special[spellID] then -- Workaround for spells which aren't tanking spells
				if isFemale(srcName) then
					send(L.Plugins["used_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used Aura Mastery
				else
					send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
				end
			end

		elseif event == "SPELL_AURA_APPLIED" then -- [X] cast [Y] on [Z]
			if pfl.BonusEnable and bonus[spellID] then
				if isFemale(srcName) then
					send(L.Plugins["used_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used [Z] (bonus)
				else
					send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID)))
				end
			-- elseif spellID == 66233 then
			-- 	if not ad_heal then -- If the Ardent Defender heal message hasn't been sent already
			-- 		send(ad:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X]'s [Y] consumed
			-- 	end
			-- 	ad_heal = false
			-- elseif spellName == HOP and IsTank(srcName) then
			-- 	if isFemale(srcName) then
			-- 		send(L.Plugins["cast_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X] cast Hand of Protection on [Z]
			-- 	else
			-- 		send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			-- 	end
			elseif pfl.TrinketsEnable and trinkets[spellID] then
				if isFemale(srcName) then
					send(L.Plugins["used_fem"]:format(icon(srcName), srcName, select(2, GetItemInfo(trinkets[spellID])))) -- [X] used [Y]
				else
					send(L.Plugins["used"]:format(icon(srcName), srcName, select(2, GetItemInfo(trinkets[spellID]))))
				end
			end

		elseif event == "SPELL_HEAL" then
			if spellID == 48153 or spellID == 66235 then -- Guardian Spirit / Ardent Defender
				local amount = ...
				ad_heal = true
				if isFemale(srcName) then
					send(L.Plugins["gs_fem"]:format(icon(srcName), srcName, GetSpellLink(spellID), amount)) -- [X]'s [Y] consumed: [Z] heal
				else
					send(L.Plugins["gs"]:format(icon(srcName), srcName, GetSpellLink(spellID), amount))
				end
			end

		if 1 > 0 then
			elseif event == "SPELL_AURA_REMOVED" then
				if spells[spellID] or (spellName == HOP and IsTank(destName)) then
					send(L.Plugins["fade"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X]'s [Y] faded from [Z]
				elseif use[spellID] and IsTank(srcName) then
					send(L.Plugins["sw"]:format(GetSpellLink(spellID), icon(srcName), srcName)) -- [X] faded from [Y]
				elseif bonus[spellID] then
					send(L.Plugins["sw"]:format(GetSpellLink(spellID), icon(srcName), srcName)) -- [X] faded from [Y] (bonus)
				elseif spellID == 64205 and sacrifice[destGUID] then
					send(L.Plugins["sw"]:format(GetSpellLink(spellID), icon(srcName), srcName)) -- Divine Sacrifice faded from [Y]
					sacrifice[destGUID] = nil
				elseif special[spellID] then -- Workaround for spells which aren't tanking spells
					send(L.Plugins["sw"]:format(GetSpellLink(spellID), icon(srcName), srcName)) -- Aura Mastery faded from [X]
				elseif DIVINE_PLEA and spellID == 54428 and UnitManaMax(srcName) >= MIN_HEALER_MANA then
					send(L.Plugins["sw"]:format(GetSpellLink(spellID), icon(srcName), srcName)) -- Divine Plea faded from [X]
				end
			end
		end
	end

end

-- local function EnableDisable()
	-- if pfl.Enabled then
		-- flump:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	-- else
		-- flump:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	-- end
-- end

local function InitializeOptions()
	local add_use_label = ""
	local flump_group = {
		type = "group",
		childGroups = "tree",
		name = "Flump",
		get = function(info) return db.profile.Plugins.Flump[info[#info]] end,
		set = function(info, v, v2) db.profile.Plugins.Flump[info[#info]] = v; module:RefreshProfile(); savetables(); end,
		order = 1,
		args = {
			description = {
				type = "header",
				name = L.Plugins["Enable Flump messages"],
				order = 0,
			},
			Enabled = {
				type = "toggle",
				name = L.Plugins["Enable %s"]:format(flump.name),
				desc = L.Plugins["Flump messages enabled"],
				order = 2,
				values = Enabled,
				width = "full",
				get = function(info) return db.profile.Plugins.Flump[info[#info]] end,
				set = function(info,v) db.profile.Plugins.Flump[info[#info]] = v; module:RefreshProfile(); flump:set() end,
			},
			Chat = {
				type = "select",
				name = L.Plugins["Channel"],
				desc = L.Plugins["Channel"],
				order = 3,
				values = chats_loc,
				get = function(info) return db.profile.Plugins.Flump[info[#info]] end,
				set = function(info, index) db.profile.Plugins.Flump[info[#info]] = index > 4 and nil or index; module:RefreshProfile() end,
			},
			separator3 = {
				type = "description",
				name = " ",
				order = 4,
				width = "full",
			},
			Portals = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Portals"],
				order = 20,
				width = "full",
					args = {
						PortalsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						PortalsGroup = {
							order = 2,
							name = L.Plugins["Portals"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.PortalsEnable end,
								args = {
								},
						},
					},
			},
			Spells = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Spells"],
				order = 30,
				width = "full",
					args = {
						SpellsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						SpellsGroup = {
							order = 2,
							name = L.Plugins["Spells"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.SpellsEnable end,
							args = {
								},
						},
					},
			},
			Bots = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Bots"],
				order = 40,
				width = "full",
					args = {
						BotsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						BotsGroup = {
							order = 2,
							name = L.Plugins["Bots"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.BotsEnable end,
								args = {
								},
						},
					},
			},
			Use = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Use"],
				order = 50,
				width = "full",
					args = {
						UseEnable = {
							order = 1 ,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						InCombat = {
							type = "toggle",
							name = L.Plugins["combat"],
							desc = L.Plugins["Only in combat"],
							order = 2,
							values = InCombat,
							disabled = function() return not pfl.UseEnable end,
						},
						OnlyTanks = {
							type = "toggle",
							name = L.Plugins["only_tanks"],
							desc = L.Plugins["Only tanks"],
							order = 3,
							values = OnlyTanks,
							disabled = function() return not pfl.UseEnable end,
						},
						UseGroup = {
							order = 4,
							name = L.Plugins["Use"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.UseEnable end,
								args = {
								},
						},
				},
			},
			Rituals = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Rituals"],
				order = 60,
				width = "full",
					args = {
						RitualsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						RitualsGroup = {
							order = 2,
							name = L.Plugins["Rituals"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.RitualsEnable end,
								args = {
								},
						},
					},
			},
			Trinkets = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Trinkets"],
				order = 150,
				width = "full",
					args = {
						TrinketsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						-- TrinketsCache = {
						-- 	order = 4,
						-- 	name = L.options["Cache"],
						-- 	type = "execute",
						-- 	width = "normal",
						-- 	func = function() flump:CacheItems(50364)  end,
						-- },
						TrinketsGroup = {
							order = 2,
							name = L.Plugins["Trinkets"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.TrinketsEnable end,
								args = {
								},
						},
					},
			},
			Feasts = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Feasts"],
				order = 70,
				width = "full",
					args = {
						FeastsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						FeastsGroup = {
							order = 2,
							name = L.Plugins["Feasts"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.RitualsEnable end,
								args = {
								},
						},
					},
			},
			Misc = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Misc"],
				order = 80,
				width = "full",
					args = {
						MiscEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						MiscGroup = {
							order = 2,
							name = L.Plugins["Misc"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.MiscEnable end,
								args = {
								},
						},
				},
			},
			Bonus = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Bonus"],
				order = 90,
				width = "full",
					args = {
						BonusEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						BonusGroup = {
							order = 2,
							name = L.Plugins["Bonus"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.BonusEnable end,
								args = {
								},
						},
				},
			},
			Special = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Special"],
				order = 100,
				width = "full",
					args = {
						SpecialEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						SpecialGroup = {
							order = 2,
							name = L.Plugins["Special"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.SpecialEnable end,
								args = {
								},
						},
				},
			},
			Dispels = {
				type = "group",
				childGroups = "tab",
				name = L.Plugins["Dispels"],
				order = 200,
				width = "full",
					args = {
						DispelsEnable = {
							order = 1,
							name = L.options["Enable"],
							type = "toggle",
							width = "full",
						},
						DispelsGroup = {
							order = 2,
							name = L.Plugins["Dispels"],
							type = "group",
							guiInline = true,
							disabled = function() return not pfl.DispelsEnable end,
								args = {
								},
						},
				},
			},
		},
	}

	db.profile.Plugins.Flump.Portals = {}
	db.profile.Plugins.Flump.Spells = {}
	db.profile.Plugins.Flump.Bots = {}
	db.profile.Plugins.Flump.Use = {}
	db.profile.Plugins.Flump.Rituals = {}
	db.profile.Plugins.Flump.Trinkets = {}
	db.profile.Plugins.Flump.Feasts = {}
	db.profile.Plugins.Flump.Misc = {}
	db.profile.Plugins.Flump.Bonus = {}
	db.profile.Plugins.Flump.Special = {}
	db.profile.Plugins.Flump.Dispels = {}

	for i, j in pairs(port) do
		flump_group.args.Portals.args.PortalsGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return port[i] end,
			set = function(info,v) port[i] = v; module:RefreshProfile(); savetables(); if port[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(spells) do
		flump_group.args.Spells.args.SpellsGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return spells[i] end,
			set = function(info,v) spells[i] = v; module:RefreshProfile(); savetables(); if spells[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(bots) do
		flump_group.args.Bots.args.BotsGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return bots[i] end,
			set = function(info,v)  bots[i] = v; module:RefreshProfile(); savetables(); if bots[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(use) do
		flump_group.args.Use.args.UseGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return use[i] end,
			set = function(info,v)  use[i] = v; module:RefreshProfile(); savetables(); if use[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(rituals) do
		flump_group.args.Rituals.args.RitualsGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return rituals[i] end,
			set = function(info,v)  rituals[i] = v; module:RefreshProfile(); savetables(); if rituals[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end;  end,
		}
	end

	for i, j in pairs(trinkets_opt) do
		local item = select(2, GetItemInfo(trinkets[i]))
		flump_group.args.Trinkets.args.TrinketsGroup.args[tostring(i)] = {
			type = "toggle",
			name = select(2, GetItemInfo(trinkets[i])) or "Not cached",
			desc = (GetItemInfo(trinkets[i]) or "Not cached") .. " (" .. (select(4, GetItemInfo(trinkets[i])) or "") .. ")",
			order = 100 + i,
			get = function(info) return trinkets_opt[i] end,
			set = function(info,v)  trinkets_opt[i] = v; module:RefreshProfile(); savetables(); if trinkets_opt[i] then print(format(spellstatus, select(2, GetItemInfo(trinkets[i])), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(2, GetItemInfo(trinkets[i])), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(feasts) do
		flump_group.args.Feasts.args.FeastsGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return feasts[i] end,
			set = function(info,v)  feasts[i] = v; module:RefreshProfile(); savetables(); if feasts[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(misc) do
		flump_group.args.Misc.args.MiscGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = 100 + i,
			get = function(info) return misc[i] end,
			set = function(info,v)  misc[i] = v; module:RefreshProfile(); savetables(); if misc[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(bonus) do
		flump_group.args.Bonus.args.BonusGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = i,
			get = function(info) return bonus[i] end,
			set = function(info,v)  bonus[i] = v; module:RefreshProfile(); savetables(); if bonus[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(special) do
		flump_group.args.Special.args.SpecialGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			desc = GetSpellInfo(i),
			order = i,
			get = function(info) return special[i] end,
			set = function(info,v)  special[i] = v; module:RefreshProfile(); savetables(); if special[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	for i, j in pairs(dispels) do
		flump_group.args.Dispels.args.DispelsGroup.args[tostring(i)] = {
			type = "toggle",
			name = GetSpellInfo(i),
			icon = select(3, GetSpellInfo(i)),
			width = "normal",
			order = i,
			get = function(info) return dispels[i] end,
			set = function(info,v)  dispels[i] = v; module:RefreshProfile(); savetables(); if dispels[i] then print(format(spellstatus, select(1, GetSpellLink(i)), "|cff00ff00" .. L.options["on"] .. "|r")) else print(format(spellstatus, select(1, GetSpellLink(i)), "|cffff0000" .. L.options["off"] .. "|r")) end; end,
		}
	end

	module.plugins_group = flump_group
end

function module:OnInitialize()

	db = addon.db
	if db.profile.Plugins.Flump == nil then
		db.profile.Plugins.Flump = defaults
	else
		if db.profile.Plugins.Flump.Portals ~= nil then
			if next(db.profile.Plugins.Flump.Portals) ~= nil then
				port = db.profile.Plugins.Flump.Portals
			end
		end
		if db.profile.Plugins.Flump.Spells ~= nil then
			if next(db.profile.Plugins.Flump.Spells) ~= nil then
				spells = db.profile.Plugins.Flump.Spells
--				print(spells)
			end
		end
		if db.profile.Plugins.Flump.Bots ~= nil then
			if next(db.profile.Plugins.Flump.Bots) ~= nil then
				bots = db.profile.Plugins.Flump.Bots
			end
		end
		if db.profile.Plugins.Flump.Use ~= nil then
			if next(db.profile.Plugins.Flump.Use) ~= nil then
				use = db.profile.Plugins.Flump.Use
			end
		end
		if db.profile.Plugins.Flump.Rituals ~= nil then
			if next(db.profile.Plugins.Flump.Rituals) ~= nil then
				rituals = db.profile.Plugins.Flump.Rituals
			end
		end
		if db.profile.Plugins.Flump.Trinkets ~= nil then
			if next(db.profile.Plugins.Flump.Trinkets) ~= nil then
				trinkets_opt = db.profile.Plugins.Flump.Trinkets
			end
		end
		if db.profile.Plugins.Flump.Feasts ~= nil then
			if next(db.profile.Plugins.Flump.Feasts) ~= nil then
				feasts = db.profile.Plugins.Flump.Feasts
			end
		end
		if db.profile.Plugins.Flump.Misc ~= nil then
			if next(db.profile.Plugins.Flump.Misc) ~= nil then
				misc = db.profile.Plugins.Flump.Misc
			end
		end
		if db.profile.Plugins.Flump.Bonus ~= nil then
			if next(db.profile.Plugins.Flump.Bonus) ~= nil then
				bonus = db.profile.Plugins.Flump.Bonus
			end
		end
		if db.profile.Plugins.Flump.Special ~= nil then
			if next(db.profile.Plugins.Flump.Special) ~= nil then
				special = db.profile.Plugins.Flump.Special
			end
		end
		if db.profile.Plugins.Flump.Dispels ~= nil then
			if next(db.profile.Plugins.Flump.Dispels) ~= nil then
				dispels = db.profile.Plugins.Flump.Dispels
			end
		end
	end

	module:RefreshProfile()
	OUTPUT = chats[pfl.Chat]

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")

	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end

	InitializeOptions()
	addon.Options:RegisterPlugin(module)
end

function flump:GET_ITEM_INFO_RECEIVED(arg1)
end

flump:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
flump:RegisterEvent("GET_ITEM_INFO_RECEIVED")

---------------------------------------
-- SETTINGS
---------------------------------------

function module:GetOptions()
	return module.plugins_group
end

function saveportals()
	db.profile.Plugins.Flump.Portals = port
end

function savespells()
	db.profile.Plugins.Flump.Spells = spells
end

function savebots()
	db.profile.Plugins.Flump.Bots = bots
end

function saveuse()
	db.profile.Plugins.Flump.Use = use
end

function saverituals()
	db.profile.Plugins.Flump.Rituals = rituals
end

function savetrinkets()
	db.profile.Plugins.Flump.Trinkets = trinkets_opt
end

function savefeasts()
	db.profile.Plugins.Flump.Feasts = feasts
end

function savemisc()
	db.profile.Plugins.Flump.Misc = misc
end

function savebonus()
	db.profile.Plugins.Flump.Bonus = bonus
end

function savespecial()
	db.profile.Plugins.Flump.Special = special
end

function savedispels()
	db.profile.Plugins.Flump.Dispels = dispels
end

function savetables()
	saveportals()
	savespells()
	savebots()
	saveuse()
	saverituals()
	savetrinkets()
	savefeasts()
	savemisc()
	savebonus()
	savespecial()
	savedispels()
end

function flump:set()
	if pfl.Enabled then
		print(format(status, "|cff00ff00" .. L.options["on"] .. "|r"))
		flump:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		print(format(status, "|cffff0000" .. L.options["off"] .. "|r"))
		flump:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
--	EnableDisable()
end

function module:RefreshProfile()
	if db.profile.Plugins.Flump == nil then
		db.profile.Plugins.Flump = defaults
	end
	pfl = db.profile.Plugins.Flump
	OUTPUT = chats[pfl.Chat]
end

addon:AddToRefreshProfile(RefreshProfile)

function flump:GET_ITEM_INFO_RECEIVED(itemID)
	if trinkets[itemID] then
--		print(itemID)
	end
end

function flump:CacheItems(itemID)
		for i = 1, 100 do
			item = GetItemInfo(itemID)
			if not item then
				print(format("Item %s not cached", itemID))
			else
				print(format("Item %s Cached!", itemID))
			end
		end
end

flump:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
