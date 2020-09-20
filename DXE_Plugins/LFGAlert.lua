-------------------------------------------------------------------------------
-- LFGAlert Declaration
--

local addon,L = DXE,DXE.L
local LFGAlert = CreateFrame("Frame")
local module = addon:NewModule("LFGAlert")

addon.plugins.LFGAlert = module

function LFGAlert:LFG_PROPOSAL_SHOW()
	if DXE.Alerts then
		DXE.Alerts.Dropdown(nil, "DXE_LFG_INVITE", L.Plugins["LFG Invitation"], 45, 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[72350], 5)
	end
end

function LFGAlert:LFG_PROPOSAL_FAILED()
	if DXE.Alerts then
		DXE.Alerts:QuashByPattern("DXE_LFG_INVITE")
	end
end
function LFGAlert:LFG_PROPOSAL_SUCCEEDED()
	if DXE.Alerts then
		DXE.Alerts:QuashByPattern("DXE_LFG_INVITE")
	end
end

LFGAlert:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
LFGAlert:RegisterEvent("LFG_PROPOSAL_SHOW")
LFGAlert:RegisterEvent("LFG_PROPOSAL_FAILED")
LFGAlert:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")