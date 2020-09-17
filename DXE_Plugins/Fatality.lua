-------------------------------------------------------------------------------
-- Fatality Declaration
--

local addon,L = DXE,DXE.L
local module = addon:NewModule("Fatality")
local db = addon.db
local Options = nil

addon.Fatality = module
local plugins_group = {}
local defaults = {
		profile = {
			Fatality = false
		}
	}

------------ CONFIGURATION -----------
local LIMIT = 10					-- number of deaths to report per combat session (default: 10)
local OUTPUT = "RAID"				-- announcement channel (default: "RAID")
local CHANNEL_NAME = "fatality" 	-- name of the channel to report to [note: OUTPUT must be set to "CHANNEL"] (default: "fatality")
local OVERKILL = true				-- toggle overkill (default: true)
local RAID_ICONS = true				-- toggle raid icons (default: true)
local SHORT_NUMBERS = true			-- toggle short numbers [i.e. 9431 = 9.4k] (default: true)
local EVENT_HISTORY = 1				-- number of damage events to report per person (default: 1)

local Fatality = CreateFrame("frame")
local status, death, unknown = "|cff39d7e5Fatality: %s|r", "Fatality: %s > %s", "Fatality: %s%s > Unknown"
local limit = "|cffffff00(%s) Report cannot be sent because it exceeds the maximum character limit of 255. To fix this, decrease EVENT_HISTORY in Fatality.lua and /reload your UI.|r"
local special = { ["SPELL_DAMAGE"] = true, ["SPELL_PERIODIC_DAMAGE"] = true, ["RANGE_DAMAGE"] = true }
local instances = {	["The Ruby Sanctum"] = true, ["The Obsidian Sanctum"] = true }
local spirit, candidates, units = GetSpellInfo(27827), {}, {}
local count, history = 0, 0
local unit_health, channel_id

-- Upvalues
local GetInstanceDifficulty, GetRaidRosterInfo = GetInstanceDifficulty, GetRaidRosterInfo
local UnitInRaid, UnitIsDead, UnitIsFeignDeath = UnitInRaid, UnitIsDead, UnitIsFeignDeath
local UnitClass, UnitGUID, UnitExists, UnitBuff = UnitClass, UnitGUID, UnitExists, UnitBuff
local GetTime, format, wipe, type, band = GetTime, string.format, wipe, type, bit.band

Fatality:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

local rt, path = "{rt%d}", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d.blp:0|t"
local rt1, rtmask = COMBATLOG_OBJECT_RAIDTARGET1, COMBATLOG_OBJECT_SPECIAL_MASK

local function icon(flag)
	if not RAID_ICONS then return "" end
	local number, mask, mark
	if band(flag, rtmask) ~= 0 then
		for i=1,8 do
			mask = rt1 * (2 ^ (i - 1))
			mark = band(flag, mask) == mask
			if mark then number = i break end
		end
	end
	return number and (OUTPUT == "SELF" and format(path, number) or format(rt, number)) or ""
end

local function shorten(n)
	if not (SHORT_NUMBERS and type(n) == "number") then return n end
	if n >= 10000000 then
		return format("%.1fM", n/1000000)
	elseif n >= 1000000 then
		return format("%.2fM", n/1000000)
	elseif n >= 100000 then
		return format("%.fk", n/1000)
	elseif n >= 1000 then
		return format("%.1fk", n/1000)
	else
		return n
	end
end

local function color(name)
	if OUTPUT ~= "SELF" then return name end
	if not UnitExists(name) then return format("|cffff0000%s|r", name) end
	local _, class = UnitClass(name)
	local color = _G["RAID_CLASS_COLORS"][class]
	return format("|cff%02x%02x%02x%s|r", color.r*255, color.g*255, color.b*255, name)
end

local function send(message)
	if OUTPUT == "SELF" then
		print(message)
	else
		local where
		if OUTPUT == "CHANNEL" then
			where = channel_id
		end
		SendChatMessage(message, OUTPUT, nil, where)
	end
end

local function shuffle(t)
    for i=1,#t-1 do
	    t[i].time = t[i+1].time
		t[i].srcGUID = t[i+1].srcGUID
		t[i].srcName = t[i+1].srcName
		t[i].srcFlags = t[i+1].srcFlags
		t[i].destGUID = t[i+1].destGUID 	
		t[i].destName = t[i+1].destName 	
		t[i].destFlags = t[i+1].destFlags 	
		t[i].spellID = t[i+1].spellID 	
		t[i].spellName = t[i+1].spellName 	
		t[i].environment = t[i+1].environment
		t[i].amount = t[i+1].amount 	
		t[i].overkill = t[i+1].overkill 	
		t[i].crit = t[i+1].crit 		
		t[i].crush = t[i+1].crush 		
    end
end

function Fatality:FormatOutput(guid, known)
	
	local c = candidates[guid]
	local destName, destFlags = c[#c].destName, c[#c].destFlags
		
	local destIcon = icon(destFlags)
	
	if not known then
		return unknown:format(destIcon, destName)
	end
	
	local dest = format("%s%s", destIcon, color(c[1].destName))
	
	local source, info, full
	
	for i=1,EVENT_HISTORY do
	
		local e = c[i]
		if not e then break end
		
		if e.srcName then
			local srcIcon = icon(e.srcFlags)
			source = format("%s%s", srcIcon, color(e.srcName))
		else
			source = color("Unknown")
		end
		
		local ability = (e.spellID and GetSpellLink(e.spellID)) or e.environment or "Melee"
		
		if e.amount > 0 then 
			local amount = (OVERKILL and (e.amount - e.overkill)) or e.amount
			local overkill = (OVERKILL and e.overkill > 0) and format(" (O: %s)", shorten(e.overkill)) or ""
			amount = shorten(amount)
			if not e.environment then
				local crit_crush = (e.crit and " (Critical)") or (e.crush and " (Crushing)") or ""
				-- SPELL_DAMAGE, SPELL_PERIODIC_DAMAGE, RANGE_DAMAGE, SWING_DAMAGE
				info = format("%s %s%s%s [%s]", amount, ability, overkill, crit_crush, source)
			else
				-- ENVIRONMENTAL_DAMAGE
				info = format("%s %s [%s]", amount, ability, source)
			end
		else
			-- SPELL_INSTAKILL
			info = format("%s [%s]", ability, color("Unknown"))
		end
		
		full = format("%s%s%s", full or "", info, c[i + 1] and " + " or "")
		
	end
	
	local msg = format(death, dest, full)

	if msg:len() > 255 and OUTPUT ~= "SELF" then
		local err = format(limit, destName)
		print(format(status, err))
		return
	end
	
	return msg
	
end

function Fatality:RecordDamage(now, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, environment, amount, overkill, crit, crush)
	
	-- If the table doesn't already exist, create it
	if not candidates[destGUID] then
		candidates[destGUID] = {}
	end
	
	-- Store the table in a temporary variable
	local t = candidates[destGUID]

	if EVENT_HISTORY == 1 then
		history = 1
	elseif #t < EVENT_HISTORY then
        history = #t + 1
    else
        shuffle(t)
        history = EVENT_HISTORY
    end
	
	if not t[history] then
		t[history] = {}
	end
	
	t[history].time = now
    t[history].srcGUID = srcGUID
	t[history].srcName = srcName
	t[history].srcFlags = srcFlags
	t[history].destGUID = destGUID
	t[history].destName = destName
	t[history].destFlags = destFlags
	t[history].spellID = spellID
	t[history].spellName = spellName
	t[history].environment = environment
	t[history].amount = amount
	t[history].overkill = overkill
	t[history].crit = crit
	t[history].crush = crush
	
end

function Fatality:ReportDeath(guid)
	if not candidates[guid] then return end
	local report, now, candidate = "", GetTime(), candidates[guid]
	local id = candidate[1].destGUID
	if candidate and count < LIMIT then
		-- If the last damage event is more than 2 seconds before
		-- UNIT_DIED fired, assume the cause of death is unknown
		if (now - candidate[#candidate].time) < 2 then
			report = self:FormatOutput(id, true)
		else
			report = self:FormatOutput(id)
		end
		send(report)
		count = count + 1
		candidates[guid] = nil
	end
end

function Fatality:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, ...)
	
	if not UnitInRaid(destName) then return end
	
	local spellID, spellName, amount, overkill, environment, crit, crush
	
	if special[event] then
		spellID, spellName, spellSchool, amount, overkill, _, _, _, _, crit, _, crush = ...
	elseif event == "SWING_DAMAGE" then
		amount, overkill, _, _, _, _, crit, _, crush = ...
	elseif event == "SPELL_INSTAKILL" then
		spellID = ...
		amount = -1
	elseif event == "ENVIRONMENTAL_DAMAGE" then
		environment, amount, overkill = ...
	end
	
	if amount then
		self:RecordDamage(GetTime(), srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, environment, amount, overkill, crit, crush)
	end
	
	if event == "UNIT_DIED" and not UnitIsFeignDeath(destName) then
		self:ReportDeath(destGUID)
	end
	
end

function Fatality:ClearData()
	count = 0
	wipe(candidates)
end

function Fatality:RegisterEvents()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	if unit_health then
		self:RegisterEvent("UNIT_HEALTH")
		self:RegisterEvent("RAID_ROSTER_UPDATE")
	end
	channel_id = GetChannelName(CHANNEL_NAME)
end

function Fatality:UnregisterEvents()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	if unit_health then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("RAID_ROSTER_UPDATE")
	end
end

function Fatality:CheckEnable()
	if not self.db.enabled then return end
	local _, instance = IsInInstance()
	if instance == "raid" then
		unit_health = instances[GetRealZoneText()] -- Only use UNIT_HEALTH to determine deaths in predefined instances 
		self:ClearData()
		self:RegisterEvents()
	else
		self:UnregisterEvents()
	end
end

function Fatality:UNIT_HEALTH(unit)
	if not units[unit] then return end
	if UnitIsDead(unit) or UnitBuff(unit, spirit) then
		self:ReportDeath(UnitGUID(unit))
	end
end

function Fatality:RAID_ROSTER_UPDATE()
	wipe(units)
	local name, group
	local max_group = 6 - (GetInstanceDifficulty() % 2) * 3
	for i=1,40 do
		name, _, group = GetRaidRosterInfo(i)
		if name and group < max_group then
			units["raid" .. i] = true
		end
	end
end

function Fatality:PLAYER_REGEN_DISABLED()
	self:ClearData()
end

function Fatality:ZONE_CHANGED()
	self:CheckEnable()
end

function Fatality:PLAYER_LOGIN()
	self:CheckEnable()
end

function Fatality:ZONE_CHANGED_NEW_AREA()
	self:CheckEnable()
end

function Fatality:PLAYER_ENTERING_WORLD()
	if not unit_health then -- Just in case Z_C or Z_C_N_A fire before P_E_W
		self:CheckEnable()
	end
end

function Fatality:ADDON_LOADED(addon)
	if addon ~= "Fatality" then return end
	FatalityDB = FatalityDB or { enabled = true }
	self.db = FatalityDB
	SLASH_FATALITY1, SLASH_FATALITY2 = "/fatality", "/fat"
	SlashCmdList.FATALITY = function()
		if self.db.enabled then
			self:UnregisterEvents()
			self.db.enabled = false
			print(format(status, "|cffff0000off|r"))
		else
			self:RegisterEvents()
			self.db.enabled = true
			print(format(status, "|cff00ff00on|r"))
		end
	end
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local function InitializeOptions()
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end	
	local FatalityGroup = {
		type = "group",
		name = L.Plugins["Fatality"],
		order = -10,
		args = {
				Fatality = {
					type = "toggle",
					name = L.Plugins["Enable Fatality plugin"],
					order = 10,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = FatalityGroup
	addon.Options:RegisterPlugin(module)
end

function module:OnInitialize()
	InitializeOptions()	
end

function module:GetOptions()
	return module.plugins_group
end

function module:RefreshProfile() pfl = db.profile.Plugins end

Fatality:RegisterEvent("ADDON_LOADED")