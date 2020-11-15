local SPELL_DOMINATE = {
	[71289] = true,
}

local SPELL_BITE = {
	[70946] = true,
	[71475] = true,
	[71476] = true,
	[71477] = true,
	[71726] = true,
	[71727] = true,
	[71728] = true,
	[71729] = true,
}

local LADY_GUID, LICH_GUID, LANA_GUID

local DOMINATE_COOLDOWN = {
							Pull = 31, -- С пулла
							Cast = 40, -- С каста
						}
local d_cd
local dominate_time, dominate_elapsed, dominate_remain
local weapon_off = false
local weapons = {}

local Enabled = false
local LadyFight, LichFight, LanaFight = false

local plague = GetSpellInfo(70337)

local f = CreateFrame("Frame")
local addon,L = DXE,DXE.L
local EDB = addon.EDB
local Options = nil

local module = addon:NewModule("Helper")
addon.plugins.Helper = module

local db = addon.db
local pfl

local defaults = {
		LadyHelperEnabled = false,
		LanathelBitesEnable = true,
		LichPlagueJumpEnabled = true,
}

local plugins_group = {}

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("CHAT_MSG_MONSTER_YELL")
f:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)

function f:PLAYER_REGEN_ENABLED()
	f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	weapon_off = false
end

function f:PLAYER_REGEN_DISABLED()
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:CHAT_MSG_MONSTER_YELL(text, playerName, ...)
	local _, instance = IsInInstance()
	if instance ~= "raid" then return end

--	if L.chat_citadel == nil then return end

	if pfl.LadyHelperEnabled then
		if L.chat_citadel ~= nil then
			if strfind(text, L.chat_citadel["^What is this disturbance"]) then
				dominate_time = GetTime()
				d_cd = DOMINATE_COOLDOWN.Pull
				LadyFight = true
				print("|cffff0000L|r|cff1784d1ady|r |cffff0000H|r|cff1784d1elper|r: Бой начат. |cff00ff00Аддон включен|r")
			end
		end
	end

	if pfl.LichPlagueJumpEnabled then
		if L.chat_citadel["^So the Light's vaunted justice has finally arrived"] ~= nil then
			if strfind(text, L.chat_citadel["^So the Light's vaunted justice has finally arrived"]) then
				LichFight = true
		--		print("LichFight == " .. tostring(LichFight))
			end
		end
	end

	if pfl.LanathelBitesEnable then
		if L.chat_citadel["^It was"] ~= nil then
			if strfind(text, L.chat_citadel["^It was"]) then
				LanaFight = true
				print("LanaFight == " .. tostring(LanaFight))
			end
		end
	end
end

function f:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, school, ...)

	local extraSpellID, extraSpellName, extraSchool = ...
	local weapon, macro

	if pfl.LanathelBitesEnable and LanaFight then
		if (event == "SPELL_DAMAGE" or event == "SPELL_MISSED") and SPELL_BITE[spellID] then
			SendChatMessage(format(L.Plugins["%s bites %s"], srcName, destName), "RAID")
		end
		if (event == "SPELL_CAST_SUCCESS" and spellID == 71510) then
			LANA_GUID = srcGUID
		end
		if (event == "UNIT_DIED" or event == "PARTY_KILL") then
			if destGUID == LANA_GUID then
				LadyFight = false
			end
		end
	end

	if pfl.LadyHelperEnabled and LadyFight then
		if dominate_time ~= nil then
			dominate_elapsed = GetTime() - dominate_time
			dominate_remain = d_cd - dominate_elapsed
			if (dominate_remain < 2 and dominate_remain > 0) then
				if not weapon_off then
					f:PutOffWeapon()
					weapon_off = true
				end
			end
		end

		if SPELL_DOMINATE[spellID] and event == "SPELL_AURA_APPLIED" then
			LADY_GUID = srcGUID
			dominate_time = GetTime()
			weapon_off = false
			d_cd = DOMINATE_COOLDOWN.Cast
		end

		if (event == "UNIT_DIED" or event == "PARTY_KILL") then
			if destGUID == LADY_GUID then
				f:LadyDead()
			end
		end

		if SPELL_DOMINATE[spellID] and event == "SPELL_AURA_REMOVED" then
--			print(GetSpellInfo(spellID) .. " " .. spellID)
			for i = 1, 3 do
				if weapons[i] ~= nil then
					weapon = GetItemInfo(weapons[i])
					macro = "/equipslot " .. tostring(15 + i) .. " " .. weapon
--					print(macro)
					RunMacroText(macro)
					RunMacro("Lady")
				end
			end
		end
	end

	if pfl.LichPlagueJumpEnabled and LichFight then
		if event == "SPELL_DISPEL" and extraSpellName == plague then
			print(format("Dispel: %s [%s] -> %s [%s]", srcName, spellName, destName, extraSpellName))
			f:PlagueScan()
		end

		if event == "SPELL_CAST_SUCCESS" and spellName == GetSpellInfo(73914) then
			LICH_GUID = srcGUID
		end

		if (event == "UNIT_DIED" or event == "PARTY_KILL") then
			if destGUID == LICH_GUID then
				print("Lich is DEAD")
				LichFight = false
			end
		end
	end
end

function f:ADDON_LOADED(addon)
	LadyFight = false
	LichFight = false
	LanaFight = false
end

local function InitializeOptions()
	local helper_group = {
		type = "group",
		childGroups = "tab",
		name = L.Plugins["Helper"],
		get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
		set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile() end,
		order = 2,
		args = {
			description = {
				type = "header",
				name = L.Plugins["Some helpful options"],
				order = 0,
			},
			LadyHelperEnabled = {
				type = "toggle",
				name = L.Plugins["Enable Lady Helper"],
				desc = L.Plugins["Puts off weapons before Mind Control"],
				order = 10,
				width = "full",
				get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
				set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
			LadyHelperHelpButton = {
				type = "execute",
				name = L.Plugins["Create Macros"],
				-- desc = L.Plugins["Puts off weapons before Mind Control"],
				order = 12,
				width = "normal",
				func = function() f:PrintHelp(pfl.LadyHelperMacroName)  end,
				-- get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
				-- set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
			LadyHelperMacroName = {
				type = "input",
				name = L.Plugins["Create Macro"],
				desc = L.Plugins["Macro name"],
				order = 11,
				width = "normal",
				get = function(info) return db.profile.Plugins.Helper[info[#info]] or "LadyHelper" end,
				set = function(info,v) if v == "" then v = "LadyHelper" end; db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
			LanathelBitesEnable = {
				type = "toggle",
				name = L.Plugins["Enable Lanathel bites announces to the Raid channel"],
				desc = L.Plugins["Enable Lanathel bites announces to the Raid channel"],
				order = 20,
				width = "full",
				get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
				set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
			LichPlagueJumpEnabled = {
				type = "toggle",
				name = L.Plugins["Announce when dispelled Plague jumps to another Raid Member"],
				desc = L.Plugins["Announce when dispelled Plague jumps to another Raid Member"],
				order = 30,
				width = "full",
				get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
				set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
		},
	}
	module.plugins_group = helper_group
end

function module:OnInitialize()
	db = addon.db
	if db.profile.Plugins.Helper == nil then
		db.profile.Plugins.Helper = defaults
	end

	module:RefreshProfile()

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

function module:RefreshProfile()
	if db.profile.Plugins.Helper == nil then
		db.profile.Plugins.Helper = defaults
	end
	pfl = db.profile.Plugins.Helper
end

addon:AddToRefreshProfile(RefreshProfile)

function module:GetOptions()
	return module.plugins_group
end

function f:PutOffWeapon()
	local itemName, itemLink
	for i = 1, 3 do
		weapons[i] = GetInventoryItemID("player", 15 + i)
		if weapons[i] ~= nil then
			PickupInventoryItem(15 + i)
			PutItemInBackpack()
			itemName, itemLink = GetItemInfo(weapons[i])
			print("|cffff0000L|r|cff1784d1ady|r |cffff0000H|r|cff1784d1elper|r: |cffff0000Оружие|r " .. itemLink .. " |cff00ff00убрано в сумку|r")
		end
	end
end

function f:PrintHelp(macroname)
	local weapon, macro, macroId, name
	if macroname == nil then name = "LadyHelper" else name = macroname end
	macro = ""
	for i = 1, 3 do
		weapon = GetInventoryItemID("player", 15 + i)
		if weapon ~= nil then
			itemName, itemLink = GetItemInfo(weapon)
			macro = macro ..  "/equipslot " .. tostring(15 + i) .. " " .. itemName .. "\n"
		end
	end
	if GetMacroInfo(name) ~= nil then
		DeleteMacro(name)
		print("|cffff0000Старый макрос|r |cff00ff00" .. name .. "|r |cffff0000удален|r")
	end
	macroId = CreateMacro(name, 1, macro, true)
	if macroId ~= nil then
		macro  = "|cffffff00Создан макрос с именем|r |cff00ff00" .. name .. "|r |cffffff00для персонажа|r |cff00ff00" .. GetUnitName("player") .. "|r:\n" .. macro
		print(macro)
	end
end

function f:LadyDead()
	LadyFight = false
	print("|cffff0000L|r|cff1784d1ady|r |cffff0000H|r|cff1784d1elper|r: |cff00ff00Босс убит.|r |cffff0000Аддон отключен|r")
	weapon_off = true
end

do
--	local plague = GetSpellInfo(70337)
	local function scanRaid()
		for i = 1, GetNumRaidMembers() do
			local player = GetRaidRosterInfo(i)
			if player then
				local debuffed, _, _, _, _, _, expire = UnitDebuff(player, plague)
				if debuffed and (expire - GetTime()) > 13 then
--				if debuffed then
--					print(format("plague: %s; debuffed: %s; expire: %s; now: %s; expire-now: %s", plague, debuffed, tostring(expire), tostring(GetTime()), tostring(expire - GetTime())))
--					if UnitIsUnit(player, "player") then
						DXE.Alerts.CenterPopup(_, "necroplaguedur", format("%s: %s!", plague, player), 5, 5, "ALERT4", "GREEN", "GREEN", false, DXE.ST[70337])
--					end
					SendChatMessage(format(L.Plugins["Plague jumped to %s"], player), "RAID")
--					print(format(L.Plugins["Plague jumped to %s"], player))
				end
			end
		end
	end
	function f:PlagueScan()
		DXE:ScheduleTimer(scanRaid, 0.2)
	end
end
