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

local LADY_GUID, LICH_GUID

local DOMINATE_COOLDOWN = {
							Pull = 31, -- С пулла
							Cast = 40, -- С каста
						}
local d_cd
local dominate_time, dominate_elapsed, dominate_remain
local weapon_off = false
local weapons = {}

local Enabled = false
local LadyFight, LichFight = false

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
	if pfl.LadyHelperEnabled and find(text, "^Как вы смеете ступать") then
		dominate_time = GetTime()
		d_cd = DOMINATE_COOLDOWN.Pull
		LadyFight = true
		print("|cffff0000L|r|cff1784d1ady|r |cffff0000H|r|cff1784d1elper|r: Бой начат. |cff00ff00Аддон включен|r")
	end
	
	if pfl.LichPlagueJumpEnabled and find(text, L.chat_citadel["^So the Light's vaunted justice has finally arrived"]) then
		LichFight = true
		print("LichFight == " .. LichFight)
	end
end

function f:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, school, ...)

	local spellSchool, extraSpellID, extraSpellName, extraSchool = ... 
	local weapon, macro
	
	if pfl.LanathelBitesEnable then
		if event == "SPELL_CAST_START" and SPELL_BITE[spellID] then
			SendChatMessage(format("%s кусает %s", srcName, destName), "RAID")
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
		if event == "SPELL_DISPEL" then
			PlagueScan()
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
end

local function InitializeOptions()
	local helper_group = {
		type = "group",
		childGroups = "tab",
		name = "Helper",
		get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
		set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile() end,
		order = 1,
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
				order = 1,
				width = "full",
				get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
				set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
			LanathelBitesEnable = {
				type = "toggle",
				name = L.Plugins["Enable Lanathel bites announces to the Raid channel"],
				desc = L.Plugins["Enable Lanathel bites announces to the Raid channe"],
				order = 2,
				width = "full",
				get = function(info) return db.profile.Plugins.Helper[info[#info]] end,
				set = function(info,v) db.profile.Plugins.Helper[info[#info]] = v; module:RefreshProfile(); end,
			},
			LichPlagueJumpEnabled = {
				type = "toggle",
				name = L.Plugins["Announce when dispelled Plague jumps to another Raid Member"],
				desc = L.Plugins["Announce when dispelled Plague jumps to another Raid Member"],
				order = 3,
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

function f:LadyDead()
	LadyFight = false
	print("|cffff0000L|r|cff1784d1ady|r |cffff0000H|r|cff1784d1elper|r: |cff00ff00Босс убит.|r |cffff0000Аддон отключен|r")
	weapon_off = true
end

do
	local plague = GetSpellInfo(70337)
	local function scanRaid()
--		DXE.Alerts.CenterPopup(_, "necroplaguedur", format("%s: %s!",SN[70337],L.alert["YOU"]).."!", 5, 5, "ALERT3", "GREEN", "GREEN", false, DXE.ST[70337])
		for i = 1, GetNumRaidMembers() do
			local player = GetRaidRosterInfo(i)
			if player then
				local debuffed, _, _, _, _, _, expire = UnitDebuff(player, plague)
				if debuffed and (expire - GetTime()) > 13 then
					if UnitIsUnit(player, "player") then 
						DXE.Alerts.CenterPopup(_, "necroplaguedur", format("%s: %s!",SN[70337],L.alert["YOU"]).."!", 5, 5, "ALERT3", "GREEN", "GREEN", false, DXE.ST[70337])
					else
						print(format("Чума перекинулась на %s", player))
					end
				end
			end
		end
	end
	function PlagueScan()
		DXE:ScheduleTimer(scanRaid, 0.8)
	end
end
