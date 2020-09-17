-------------------------------------------------------------------------------
-- Test2 Declaration
--

local addon,L = DXE,DXE.L
local test2 = CreateFrame("Frame")
local module = addon:NewModule("Test2")
local db = addon.db
local Options = nil

addon.plugins.Test2 = module
local plugins_group = {}
local defaults = {
		profile = {
			Test2 = false
		}
	}

local function InitializeOptions()
	
	local Test2Group = {
		type = "group",
		name = L.Plugins["Test2"],
		order = 3,
		args = {
				Test2 = {
					type = "toggle",
					name = L.Plugins["Test2Test2Test2Test2Test2"],
					order = 4,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = Test2Group
	
end

function module:OnInitialize()
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end
	self.db = addon.db:RegisterNamespace("Test2", defaults)
	db = addon.db
	pfl = db.profile.Plugins

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")
	
	InitializeOptions()
	
	addon.Options:RegisterPlugin(module)	
end

function module:GetOptions()
	return module.plugins_group
end

function module:RefreshProfile() pfl = db.profile.Plugins end
test2:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
