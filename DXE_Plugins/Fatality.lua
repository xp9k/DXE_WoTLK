-------------------------------------------------------------------------------
-- Fatality Declaration
--

local addon,L = DXE,DXE.L
local module = addon:NewModule("Fatality")
local db = addon.db
local pfl
local Options = nil

addon.plugins.Fatality = module
local plugins_group = {}

------------ CONFIGURATION -----------
local defaults = {
	LIMIT = 10,						-- number of deaths to report per combat session (default: 10)
	OUTPUT = "RAID"	,				-- announcement channel (default: "RAID")
	CHANNEL_NAME = "fatality",		-- name of the channel to report to [note: OUTPUT must be set to "CHANNEL"] (default: "fatality")
	OVERKILL = true,				-- toggle overkill (default: true)
	RAID_ICONS = true,				-- toggle raid icons (default: true)
	SHORT_NUMBERS = true,			-- toggle short numbers [i.e. 9431 = 9.4k] (default: true)
	EVENT_HISTORY = 1,				-- number of damage events to report per person (default: 1)
}

local chats = {
	"NONE",
	"SELF",
	"PARTY",
	"RAID",
	"CHANNEL",
}

local chats_loc = {
	L.Plugins["NONE"],
	L.Plugins["SELF"],
	L.Plugins["PARTY"],
	L.Plugins["RAID"],
	L.Plugins["CHANNEL"],
}

local fatality = CreateFrame("frame")
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

fatality:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

local rt, path = "{rt%d}", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d.blp:0|t"
local rt1, rtmask = COMBATLOG_OBJECT_RAIDTARGET1, COMBATLOG_OBJECT_SPECIAL_MASK

local function icon(flag)
	if not pfl.RAID_ICONS then return "" end
	local number, mask, mark
	if band(flag, rtmask) ~= 0 then
		for i=1,8 do
			mask = rt1 * (2 ^ (i - 1))
			mark = band(flag, mask) == mask
			if mark then number = i break end
		end
	end
	return number and (chats[pfl.OUTPUT] == "SELF" and format(path, number) or format(rt, number)) or ""
end

local function shorten(n)
	if not (pfl.SHORT_NUMBERS and type(n) == "number") then return n end
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
	if chats[pfl.OUTPUT] ~= "SELF" then return name end
	if not UnitExists(name) then return format("|cffff0000%s|r", name) end
	local _, class = UnitClass(name)
	local color = _G["RAID_CLASS_COLORS"][class]
	return format("|cff%02x%02x%02x%s|r", color.r*255, color.g*255, color.b*255, name)
end

local function send(message)
	if chats[pfl.OUTPUT] == "SELF" then
		print(message)
	else
		local where
		if chats[pfl.OUTPUT] == "CHANNEL" then
			where = channel_id
		end
		SendChatMessage(message, chats[pfl.OUTPUT], nil, where)
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

function fatality:FormatOutput(guid, known)
	
	local c = candidates[guid]
	local destName, destFlags = c[#c].destName, c[#c].destFlags
		
	local destIcon = icon(destFlags)
	
	if not known then
		return unknown:format(destIcon, destName)
	end
	
	local dest = format("%s%s", destIcon, color(c[1].destName))
	
	local source, info, full
	
	for i=1,pfl.EVENT_HISTORY do
	
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
			local amount = (pfl.OVERKILL and (e.amount - e.overkill)) or e.amount
			local overkill = (pfl.OVERKILL and e.overkill > 0) and format(" (O: %s)", shorten(e.overkill)) or ""
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

	if msg:len() > 255 and chats[pfl.OUTPUT] ~= "SELF" then
		local err = format(limit, destName)
		print(format(status, err))
		return
	end
	
	return msg
	
end

function fatality:RecordDamage(now, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, environment, amount, overkill, crit, crush)
	
	-- If the table doesn't already exist, create it
	if not candidates[destGUID] then
		candidates[destGUID] = {}
	end
	
	-- Store the table in a temporary variable
	local t = candidates[destGUID]

	if pfl.EVENT_HISTORY == 1 then
		history = 1
	elseif #t < pfl.EVENT_HISTORY then
        history = #t + 1
    else
        shuffle(t)
        history = pfl.EVENT_HISTORY
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

function fatality:ReportDeath(guid)
	if not candidates[guid] then return end
	local report, now, candidate = "", GetTime(), candidates[guid]
	local id = candidate[1].destGUID
	if candidate and count < pfl.LIMIT then
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

function fatality:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, ...)
	
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

function fatality:ClearData()
	count = 0
	wipe(candidates)
end

function fatality:RegisterEvents()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	if unit_health then
		self:RegisterEvent("UNIT_HEALTH")
		self:RegisterEvent("RAID_ROSTER_UPDATE")
	end
	channel_id = GetChannelName(pfl.CHANNEL_NAME)
end

function fatality:UnregisterEvents()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	if unit_health then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("RAID_ROSTER_UPDATE")
	end
end

function fatality:CheckEnable()
	if not pfl.Enabled then return end
	local _, instance = IsInInstance()
	if instance == "raid" then
		unit_health = instances[GetRealZoneText()] -- Only use UNIT_HEALTH to determine deaths in predefined instances 
		self:ClearData()
		self:RegisterEvents()
	else
		self:UnregisterEvents()
	end
end

function fatality:UNIT_HEALTH(unit)
	if not units[unit] then return end
	if UnitIsDead(unit) or UnitBuff(unit, spirit) then
		self:ReportDeath(UnitGUID(unit))
	end
end

function fatality:RAID_ROSTER_UPDATE()
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

function fatality:PLAYER_REGEN_DISABLED()
	self:ClearData()
end

function fatality:ZONE_CHANGED()
	self:CheckEnable()
end

function fatality:PLAYER_LOGIN()
	self:CheckEnable()
end

function fatality:ZONE_CHANGED_NEW_AREA()
	self:CheckEnable()
end

function fatality:PLAYER_ENTERING_WORLD()
	if not unit_health then -- Just in case Z_C or Z_C_N_A fire before P_E_W
		self:CheckEnable()
	end
end

function fatality:ADDON_LOADED(addon)
	if addon ~= "Fatality" then return end
end

local function InitializeOptions()
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end	
	local FatalityGroup = {
		type = "group",
		name = L.Plugins["Fatality"],
		order = 2,
		args = {
				description = {
					type = "header",
					name = L.Plugins["Enable Fatality messages"],
					order = 0,
				},
				Enabled = {
					type = "toggle",
					name = L.Plugins["Enable %s"]:format("Fatality"),
					order = 2,
					width = "full",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile(); fatality:set() end,
				},
				LIMIT = {
					type = "range",
					name = L.Plugins["Number of deaths to report per combat session (default: 10)"],
					order = 3,
					min = 1,
					max = 25,
					step = 1,
					width = "full",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile() end,
				},
				OUTPUT = {
					type = "select",
					name = L.Plugins["Channel"],
					order = 4,
					width = "normal",
					values = chats_loc,
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info, index) db.profile.Plugins.Fatality[info[#info]] = index > 5 and nil or index; module:RefreshProfile() end,
				},
				CHANNEL_NAME = {
					type = "input",
					name = L.Plugins["Channel name"],
					desc = L.Plugins["Name of the channel to report to (note: OUTPUT must be set to CHANNEL)"],
					usage = "fatality",
					order = 5,
					width = "normal",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile() end,
					disabled = function(info)
						return ((db.profile.Plugins.Fatality.OUTPUT ~= 5))
					end,
				},
				BLANK = {
					type = "description",
					name = "",
					order = 6,
					width = "full",
				},
				OVERKILL = {
					type = "toggle",
					name = L.Plugins["Fatality_OVERKILL"],
					order = 7,
					width = "normal",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile() end,
				},
				RAID_ICONS = {
					type = "toggle",
					name = L.Plugins["Fatality_RAID_ICONS"],
					order = 8,
					width = "normal",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile() end,
				},
				SHORT_NUMBERS = {
					type = "toggle",
					name = L.Plugins["Short Nnumbers (i.e. 9431 = 9.4k)"],
					order = 9,
					width = "normal",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile() end,
				},
				EVENT_HISTORY = {
					type = "range",
					name = L.Plugins["Number of damage events to report per person (default: 1)"],
					min = 1,
					max = 10,
					step = 1,
					order = 10,
					width = "full",
					get = function(info) return db.profile.Plugins.Fatality[info[#info]] end,
					set = function(info,v) db.profile.Plugins.Fatality[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = FatalityGroup
	addon.Options:RegisterPlugin(module)
end

function tdump(o)
   if type(o) == 'table' then
      local s = '{\n\t'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. tdump(v) .. ','
      end
      return s .. '}\n'
   else
      return tostring(o)
   end
end

function module:OnInitialize()
	db = addon.db
	if db.profile.Plugins.Fatality == nil then
		db.profile.Plugins.Fatality = defaults
	end
	
	module:RefreshProfile()
	
	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")
	
	InitializeOptions()	
end

function module:GetOptions()
	return module.plugins_group
end

function fatality:set()
	if pfl.Enabled then
		print(format("|cff39d7e5Fatality: %s|r", "|cffff0000on|r"))
	else
		print(format("|cff39d7e5Fatality: %s|r", "|cffff0000off|r"))
	end
end

function module:RefreshProfile() pfl = db.profile.Plugins.Fatality; fatality:CheckEnable() end

fatality:RegisterEvent("ADDON_LOADED")