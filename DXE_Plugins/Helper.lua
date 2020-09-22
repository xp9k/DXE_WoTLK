local SPELL_DOMINATE = {
	[71289] = true,
}

local DOMINATE_COOLDOWN = 40
local d_cd
local dominate_time, dominate_elapsed, dominate_remain
local weapon_off = false

local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
--f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)

function f:PLAYER_REGEN_ENABLED()
	f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	weapon_off = false
end

function f:PLAYER_REGEN_DISABLED()
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	dominate_time = GetTime()
	d_cd = 31
end

function f:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, school, ...)

	local spellSchool, extraSpellID, extraSpellName, extraSchool = ... 
	local dominate = SPELL_DOMINATE[spellID] 
	
	if SPELL_DOMINATE[spellID] and event == "SPELL_CAST_SUCCESS" then
		dominate_time = GetTime()
		weapon_off = false
		d_cd = DOMINATE_COOLDOWN
	end
	
	if dominate_time ~= nil then 	
		dominate_elapsed = GetTime() - dominate_time
		dominate_remain = d_cd - dominate_elapsed		
		if (dominate_remain < 2 and dominate_remain > 0) then
			if not weapon_off then
				f:PutOffWeapon()
			end
		end
	end
end

function f:PutOffWeapon()
	PickupInventoryItem(16);
	PutItemInBackpack();
	print("|cffff0000Оружие убрано в сумку|r")
	weapon_off = true
end