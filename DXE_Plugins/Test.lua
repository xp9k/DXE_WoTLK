-------------------------------------------------------------------------------
-- Test Declaration
--

local addon,L = DXE,DXE.L
local test = CreateFrame("Frame")
local module = addon:NewModule("Test")
local db = addon.db
local Options = nil

addon.plugins.Test = module
local plugins_group = {}
local defaults = {
		Test = false
	}

local function InitializeOptions()

	local TestGroup = {
		type = "group",
		name = L.Plugins["Test"],
		order = 1,
		args = {
				Test = {
					type = "toggle",
					name = L.Plugins["TestTestTestTestTest"],
					order = 2,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = TestGroup	
end

function module:OnInitialize()
	self.db = addon.db:RegisterNamespace("Test", defaults)
	db = addon.db
	pfl = db.profile.Plugins

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

function module:GetOptions()
	return module.plugins_group
end

function module:RefreshProfile() pfl = db.profile.Plugins end
test:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
