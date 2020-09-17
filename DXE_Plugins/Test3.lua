-------------------------------------------------------------------------------
-- Test3 Declaration
--

local addon,L = DXE,DXE.L
local test3 = CreateFrame("Frame")
local module = addon:NewModule("Test3")
local db = addon.db
local Options = nil

addon.plugins.Test3 = module
local plugins_group = {}
local defaults = {
		profile = {
			Test3 = false
		}
	}

local function InitializeOptions()
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end	
	local Test3Group = {
		type = "group",
		name = L.Plugins["Test3"],
		order = 5,
		args = {
				Test3 = {
					type = "toggle",
					name = L.Plugins["Test3Test3Test3Test3Test3"],
					order = 6,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = Test3Group
	addon.Options:RegisterPlugin(module)
end

function module:OnInitialize()
	self.db = addon.db:RegisterNamespace("Test3", defaults)
	db = addon.db
	pfl = db.profile.Plugins

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")
	
	InitializeOptions()	
end

function module:GetOptions()
	return module.plugins_group
end

function module:RefreshProfile() pfl = db.profile.Plugins end
test3:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
