-------------------------------------------------------------------------------
-- Plugins Declaration
--

local addon,L = DXE,DXE.L
local CE

local Plugins = CreateFrame("Frame")
local db = addon.db

local module = addon:NewModule("Plugins")
addon.Plugins = module

local AutoRCEnabled = false
local BossReplyEnabled = false
local DBMInterceptTimersEnabled = true
local Options = nil
local plugins_group = {}

local ReplyMessage = L.Plugins["%s is in combat with %s"]

function Plugins:READY_CHECK()
	if AutoRCEnabled then
		ConfirmReadyCheck(1)
		print(L.Plugins["|cffff2020Auto-accepted a Ready Check at |r"] .. date("|cffffd200%H:%M:%S (%I:%M:%S %p)|r"))
	end
end

function Plugins:CHAT_MSG_WHISPER(arg1, arg2, ...)
	if BossReplyEnabled and UnitAffectingCombat("player") then
		CE = addon.GetActiveEncounterData()
		if CE.key ~= "default" then 
			print(CE.triggers.scan)
			SendChatMessage(ReplyMessage:format(UnitName("player"), CE.name), "WHISPER", nil, arg2);
		end
	end
end

function Plugins:CHAT_MSG_ADDON(prefix, message, _, sender)
	if DBMInterceptTimersEnabled and prefix == "DBMv4-Pizza" then 
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
	local Plugins = {
		type = "group",
		name = L.Plugins["Plugins"],
		order = -10,
		args = {
				AutoRC = {
					type = "toggle",
					name = L.Plugins["Automatically accept ReadyCheck"],
					order = 10,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; addon:UpdatePluginsSettings() end,
				},
				BossReply = {
					type = "toggle",
					name = L.Plugins["Automatically reply for whisps while boss Encounter"],
					order = 15,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; addon:UpdatePluginsSettings() end,
				},
				DBMInterceptTimers = {
					type = "toggle",
					name = L.Plugins["Intercept DBM Pull and Puzza Timers"],
					order = 15,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; addon:UpdatePluginsSettings() end,
				},
		},
	}
	Options = addon.Options.opts.args
	Options.plugins_group = Plugins
end

function module:OnInitialize()
	InitializeOptions()
	addon.UpdatePluginsSettings()	
end

function addon:UpdatePluginsSettings()
	AutoRCEnabled = db.profile.Plugins.AutoRC	
	BossReplyEnabled = db.profile.Plugins.BossReply	
	DBMInterceptTimersEnabled = db.profile.Plugins.DBMInterceptTimers		
end

local function RefreshProfile(db)
--	AutoRCEnabled = db.profile.Plugins.AutoRC
	addon:UpdatePluginsSettings()
end

addon:AddToRefreshProfile(RefreshProfile)

Plugins:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
Plugins:RegisterEvent("READY_CHECK")
Plugins:RegisterEvent("CHAT_MSG_WHISPER")
Plugins:RegisterEvent("CHAT_MSG_ADDON")