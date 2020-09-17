-------------------------------------------------------------------------------
-- Fatality Declaration
--

local addon,L = DXE,DXE.L
local fatality = CreateFrame("Frame")
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
					name = L.Plugins["FatalityFatalityFatalityFatalityFatality"],
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
fatality:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
