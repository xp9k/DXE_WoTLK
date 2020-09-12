-------------------------------------------------------------------------------
-- flump Declaration
--

local addon,L = DXE,DXE.L
local EDB = addon.EDB
local flump = CreateFrame("Frame")
local module = addon:NewModule("Flump")

addon.Flump = module

-------------------------------------------------------------------------------
-- Locals
--

--local L = LibStub("AceLocale-3.0"):GetLocale("DXE")

local db = addon.db

local Options = {
			Enabled = true,
			Chat = 0,
			OnlyTanks = false,
			InCombat = false
			}

local OUTPUT = "SELF"			-- Which channel should the announcements be sent to?
local MIN_TANK_HP = 55000		-- How much health must a player have to be considered a tank?
local MIN_HEALER_MANA = 20000	-- How much mana must a player have to be considered a healer?
local DIVINE_PLEA = true		-- Announce when (holy) Paladins cast Divine Plea? (-50% healing)

local status = "|cff39d7e5Flump: %s|r"

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
	[6940] 	= true,	-- Hand of Sacrifice
	[20233] = true, -- Lay on Hands (Rank 1) [Fade]
	[20236] = true, -- Lay on Hands (Rank 2) [Fade]
	-- Priest
	[47788] = true, -- Guardian Spirit
	[33206] = true, -- Pain Suppression
	--Druid
	[29166] = true, -- Озарение
	--DK
	[49016] = true, -- Истерия
	--Hunter
	[20736] = true, -- Отвлекающий выстрел
	[19801] = true, -- Усмиряющий выстрел
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
	[12976] = true,	-- Last Stand [Fade]
	[871] 	= true,	-- Shield Wall
	-- Paladin
	[498] 	= true, -- Divine Protection
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
}

local toys = {
	[61031] = true, -- Toy Train Set
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

local function icon(name)
	local n = GetRaidTargetIndex(name)
	return n and format("{rt%d}", n) or ""
end

--[[
function flump:PLAYER_ENTERING_WORLD()
	local _, instance = IsInInstance()
	if FlumpEnabled then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		print("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
]]--

function IsTank(srcName)
	return not (Options.OnlyTanks and not (UnitHealthMax(srcName) >= MIN_TANK_HP) )
--	return  UnitHealthMax(srcName) >= MIN_TANK_HP or not Options.OnlyTanks
end

function flump:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, school, ...)

	if not Options.Enabled then return end

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
				send(L.Plugins["ss"]:format(destName, GetSpellLink(6203)))
				SendChatMessage(L.Plugins["ss"]:format(destName, GetSpellLink(6203)), "RAID_WARNING")
			end
			soulstones[destName] = nil
		end
	end
	
	if event == "SPELL_CAST_SUCCESS" then
		if spellID == HEROISM then
			send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used [Y] -- Heroism/Bloodlust
		elseif bots[spellID] then 
			send(L.Plugins["bot"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used a [Y] -- Bots
		elseif rituals[spellID] then
			send(L.Plugins["create"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] is casting a [Z] -- Rituals
		elseif misc[spellID] then
			send(L.Plugins["miscellaneous"]:format(srcName, GetSpellLink(spellID))) --Misc
		end
		
	elseif event == "SPELL_AURA_APPLIED" then -- Check name instead of ID to save checking all ranks
		if spellName == SOULSTONE then
			local _, class = UnitClass(srcName)
			if class == "WARLOCK" then -- Workaround for Spirit of Redemption issue
				send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(6203), icon(destName), destName)) -- [X] cast [Y] on [Z] -- Soulstone
			end
		end
		
	elseif event == "SPELL_CREATE" then
		if port[spellID] then
			send(L.Plugins["portal"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] opened a [Z] -- Portals
		elseif toys[spellID] then
			send(L.L.Plugins["bot"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used a [Z]
		end
		
	elseif event == "SPELL_CAST_START" then
		if feasts[spellID] then
			send(L.Plugins["feast"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] prepares a [Z] -- Feasts
		end
		
	elseif event == "SPELL_RESURRECT" then
		if spellName == REBIRTH then -- Check name instead of ID to save checking all ranks
			send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X] cast [Y] on [Z] -- Rebirth
		elseif spellName == CABLES then
			send(L.Plugins["res"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
		end	
		
	elseif event == "SPELL_DISPEL_FAILED" then
		local extraID, extraName = ...
		local target = fails[extraName]
		if target or destName == target then
			send(L.Plugins["dispel"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName, GetSpellLink(extraID))) -- [W]'s [X] failed to dispel [Y]'s [Z]
		end
	end

	
	if not (Options.InCombat and not UnitAffectingCombat(srcName)) then -- If the caster is in combat	
		if event == "SPELL_CAST_SUCCESS" then
			if spells[spellID] then
				send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X] cast [Y] on [Z]
			elseif spellID == 19752 then -- Don't want to announce when it fades, so
				send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- Divine Intervention
			elseif use[spellID] and IsTank(srcName) then
				send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used [Y]
			elseif spellID == 64205 and IsTank(srcName) then  -- Workaround for Divine Sacrifice issue
				send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used Divine Sacrifice
				sacrifice[srcGUID] = true
			elseif special[spellID] then -- Workaround for spells which aren't tanking spells
				send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used Aura Mastery
			elseif DIVINE_PLEA and spellID == 54428 and UnitManaMax(srcName) >= MIN_HEALER_MANA then
				send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used Divine Plea
			end
			
		elseif event == "SPELL_AURA_APPLIED" then -- [X] cast [Y] on [Z]
			if spellID == 20233 or spellID == 20236 then -- Improved Lay on Hands (Rank 1/Rank 2)
				send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			elseif bonus[spellID] then
				send(L.Plugins["used"]:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X] used [Z] (bonus)
			elseif spellID == 66233 then
				if not ad_heal then -- If the Ardent Defender heal message hasn't been sent already
					send(ad:format(icon(srcName), srcName, GetSpellLink(spellID))) -- [X]'s [Y] consumed
				end
				ad_heal = false
			elseif spellName == HOP and IsTank(srcName) then
				send(L.Plugins["cast"]:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName)) -- [X] cast Hand of Protection on [Z]
			elseif trinkets[spellID] then
				send(L.Plugins["used"]:format(icon(srcName), srcName, select(2, GetItemInfo(trinkets[spellID])))) -- [X] used [Y]
			end
		
		elseif event == "SPELL_HEAL" then
			if spellID == 48153 or spellID == 66235 then -- Guardian Spirit / Ardent Defender
				local amount = ...
				ad_heal = true
				send(L.Plugins["gs"]:format(icon(srcName), srcName, GetSpellLink(spellID), amount)) -- [X]'s [Y] consumed: [Z] heal
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

-- function flump:ADDON_LOADED(name)
	-- if name == "DXE_Flump" then
		-- flump:Init()
	-- elseif name == CORE_ADDON then
		-- addon = DXE
		-- addon.Flump = flump
	-- end
-- --	if not B_MODS and not Z_MODS then self:UnregisterEvent("ADDON_LOADED"); self.ADDON_LOADED = nil end
-- end

local function EnableDisable()
	if Options.Enabled then
		flump:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		flump:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function module:OnInitialize()
	Options = db.profile.Flump
	OUTPUT = chats[Options.Chat]
	EnableDisable()
end

flump:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

---------------------------------------
-- SETTINGS
---------------------------------------

function addon:UpdateFlumpSettings()
	Options = db.profile.Flump
	OUTPUT = chats[Options.Chat]
	EnableDisable()	
end

local function RefreshProfile(db)
	Options = db.profile.Flump
	OUTPUT = chats[Options.Chat]
	addon:UpdateFlumpSettings()
end

addon:AddToRefreshProfile(RefreshProfile)

flump:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)


