-------------------------------------------------------------------------------
-- Plugins Declaration
--

local addon,L = DXE,DXE.L
local CE

local Plugins = CreateFrame("Frame")
local db = addon.db
local pfl

local module = addon:NewModule("Plugins")
addon.Plugins = module

local Options = nil
local plugins_group = {}

local defaults = {
	profile = {
		AutoRC = false,
		BossReply = false,
		DBMInterceptTimers = true,
		},
}

local ReplyMessage = L.Plugins["%s is in combat with %s"]

function Plugins:READY_CHECK()
	if pfl.AutoRC then
		ConfirmReadyCheck(1)
		print(L.Plugins["|cffff2020Auto-accepted a Ready Check at |r"] .. date("|cffffd200%H:%M:%S (%I:%M:%S %p)|r"))
	end
end

function Plugins:CHAT_MSG_WHISPER(arg1, arg2, ...)
	if pfl.BossReply and UnitAffectingCombat("player") then
		CE = addon.GetActiveEncounterData()
		if CE.key ~= "default" then 
			print(CE.triggers.scan)
			SendChatMessage(ReplyMessage:format(UnitName("player"), CE.name), "WHISPER", nil, arg2);
		end
	end
end

function Plugins:CHAT_MSG_ADDON(prefix, message, _, sender)
	if pfl.DBMInterceptTimers and prefix == "DBMv4-Pizza" then 
		local dbm_time, dbm_message = strsplit("\t", message)
		if DXE.Alerts then
			DXE.Alerts.QuashAll()
			DXE.Alerts.Dropdown(_, "DXE_DBM_PIZZA", sender .. ": " .. dbm_message, tonumber(dbm_time), 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[72350], 5)
		end
	end
end

---------------------------------------
-- SETTINGS
---------------------------------------

local function InitializeOptions()
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end	
	local Plugs = {
		type = "group",
		name = L.Plugins["Misc"],
		order = -10,
		args = {
				AutoRC = {
					type = "toggle",
					name = L.Plugins["Automatically accept ReadyCheck"],
					order = 10,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
				BossReply = {
					type = "toggle",
					name = L.Plugins["Automatically reply for whisps while boss Encounter"],
					order = 15,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
				DBMInterceptTimers = {
					type = "toggle",
					name = L.Plugins["Intercept DBM Pull and Puzza Timers"],
					order = 15,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = Plugs
	addon.Options:RegisterPlugin(module)
end

function module:GetOptions()
	return module.plugins_group
end

function module:OnInitialize()	
	self.db = addon.db:RegisterNamespace("Plugins", defaults)
	db = addon.db
	pfl = db.profile.Plugins

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")

	InitializeOptions()	
end

function module:RefreshProfile() pfl = db.profile.Plugins end

addon:AddToRefreshProfile(RefreshProfile)

Plugins:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
Plugins:RegisterEvent("READY_CHECK")
Plugins:RegisterEvent("CHAT_MSG_WHISPER")
Plugins:RegisterEvent("CHAT_MSG_ADDON")