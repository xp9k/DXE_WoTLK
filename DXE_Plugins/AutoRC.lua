-------------------------------------------------------------------------------
-- AutoRC Declaration
--

local addon,L = DXE,DXE.L

local AutoRC = CreateFrame("Frame")
local db = addon.db

local module = addon:NewModule("AutoRC")
addon.AutoRC = module

local Enabled = false
local Options = nil

function AutoRC:READY_CHECK()
	if Enabled then
		ConfirmReadyCheck(1)
		print(L.Plugins["|cffff2020Auto-accepted a Ready Check at |r"] .. date("|cffffd200%H:%M:%S (%I:%M:%S %p)|r"))
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
	local AutoRC = {
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
					set = function(info,v) db.profile.Plugins[info[#info]] = v; addon:UpdateAutoRCSettings() end,
				},
		},
	}
	Options = addon.Options.opts.args
	Options.plugins_group = AutoRC
end

function module:OnInitialize()
	addon.UpdateAutoRCSettings()
	InitializeOptions()
end

function addon:UpdateAutoRCSettings()
	Enabled = db.profile.Plugins.AutoRC	
end

local function RefreshProfile(db)
	Enabled = db.profile.Plugins.AutoRC
	addon:UpdateAutoRCSettings()
end

addon:AddToRefreshProfile(RefreshProfile)

AutoRC:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
AutoRC:RegisterEvent("READY_CHECK")