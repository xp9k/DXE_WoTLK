-------------------------------------------------------------------------------
-- Plugins Declaration
--

local addon,L = DXE,DXE.L
local CE

local module = addon:NewModule("PluginOptions")
addon.PluginOptions = module
local db = addon.db

local Options = nil
local plugins_group = {}

---------------------------------------
-- SETTINGS
---------------------------------------

function module:InitializeOptions()
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
	Options = addon.Options
	tinsert(Options, Plugins.args)
end

function module:RegisterAddon(l)
	print(l)
end

function module:OnInitialize()
--	print(module)
	self.InitializeOptions()	
end