-------------------------------------------------------------------------------
-- LFGAlert Declaration
--

local addon,L = DXE,DXE.L
local LFGAlert = CreateFrame("Frame")

function LFGAlert:LFG_PROPOSAL_SHOW()
	if DXE.Alerts then
		DXE.Alerts.Dropdown(nil, "DXE_LFG_INVITE", L["LFG Invitation"], 45, 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[71328], 5)
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
		DXE.Alerts.Dropdown(nil, "DXE_LFG_COOLDOWN", L["LFG Cooldown"], 900, 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[71328], 5)
	end
end

function LFGAlert:CHAT_MSG_ADDON(prefix, message, _, sender)
	if prefix == "DBMv4-Pizza" then 
		local dbm_time, dbm_message = strsplit("\t", message)
		if DXE.Alerts then
			DXE.Alerts.QuashAll()
			if dbm_message == L.alert["Pull"] then
				DXE.Alerts.Dropdown(_, "DXE_DBM_PULL", sender .. ": " .. dbm_message, tonumber(dbm_time), 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[72350], 5)
			else	
				DXE.Alerts.Dropdown(_, "DXE_DBM_PIZZA", sender .. ": " .. dbm_message, tonumber(dbm_time), 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[72350], 5)
			end
		end
	end
end

LFGAlert:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
LFGAlert:RegisterEvent("LFG_PROPOSAL_SHOW")
LFGAlert:RegisterEvent("LFG_PROPOSAL_FAILED")
LFGAlert:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
LFGAlert:RegisterEvent("CHAT_MSG_ADDON")