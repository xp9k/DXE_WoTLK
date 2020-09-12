-------------------------------------------------------------------------------
-- AutoRC Declaration
--

local addon,L = DXE,DXE.L
local EDB = addon.EDB
local AutoRC = CreateFrame("Frame")
local db = addon.db

local module = addon:NewModule("AutoRC")
addon.AutoRC = module

local Enabled = false

function AutoRC:READY_CHECK()
	if Enabled then
		ConfirmReadyCheck(1)
		print(L.Plugins["|cffffd200Auto-accepted a Ready Check at |r"] .. date("|cffff2020%H:%M:%S (%I:%M:%S %p)|r"))
	end
end

---------------------------------------
-- SETTINGS
---------------------------------------

function module:OnInitialize()
	addon.UpdateAutoRCSettings()
end

function addon:UpdateAutoRCSettings()
	Enabled = db.profile.Misc.AutoRC	
end

local function RefreshProfile(db)
	Enabled = db.profile.Misc.AutoRC
	addon:UpdateAutoRCSettings()
end

addon:AddToRefreshProfile(RefreshProfile)

AutoRC:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
AutoRC:RegisterEvent("READY_CHECK")