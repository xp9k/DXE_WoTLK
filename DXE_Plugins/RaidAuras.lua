-- RaidAuras based on Bigwigs common auras
--------------------------------------------

local addon = DXE
local L = addon.L

local class_color = {}
for class,color in pairs(RAID_CLASS_COLORS) do
	class_color[class] = ("|cff%02x%02x%02x"):format(color.r * 255, color.g * 255, color.b * 255)
end
-- If needed to go Global class color
local function getclasscolor(unit)
	if unit == nil then return "nil" end
	local classc = select(2,UnitClass(unit))
	if classc == nil and unit ~= nil then return unit end
	return class_color[classc]..unit.."|r|h" or unit
end

local defaults = {
	profile = {
		Enabled = true,
		exhealer = false,
		exdps = true,
		extank = false,
		Bars = false,
		Messages = true,
		Arrows = true,
		ChatMessages = true,
		OnlyPlayer = true,
		AllPlayers = false,
		PrintMsg = true,
		sound = "ALERT13",
		color1 = "GOLD",
		BarColor = "GLOBAL",
		Flashcolor = "GREEN",
		Bloodlust = true,
		Feasts = true,
		Repair = true,
		Soulwell = true,
		SummoningStone = true,
		RallyingCry = true,
		StampedingRoar = true,
		SmokeBomb = true,
		PainSuppression = true,		
		GuardianSpirit = true,
		Barrier = true,
		DivineHymn = true,
		Tranquility = true,		
		Ironbark = true,	
		Sacrifice = true,	
		DevotionAura = true,	
		SpiritLink = true,	
		HealingTide = true,
		LifeCocoon = true,	
		Revival = true,	
		AntiMagicZone = true,		
		Rebirth = true,
		LayofHands = true,
	},
}
local combatLogMap = {}
local throttles = {}

combatLogMap.SPELL_CAST_SUCCESS = {
		--OOC
		[22700] = "Repair", -- Field Repair Bot 74A
		[44389] = "Repair", -- Field Repair Bot 110G
		[54711] = "Repair", -- Scrapbot
		[67826] = "Repair", -- Jeeves
		[157066] = "Repair", -- Walter
		[698] = "SummoningStone", -- Ritual of Summoning
		[29893] = "Soulwell", -- Create Soulwell
		--[43987] = "Refreshment", -- Conjure Refreshment Table
		-- Group
		[97462] = "RallyingCry",
		[106898] = "StampedingRoar",
		-- DPS
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		[90355] = "Bloodlust", -- Ancient Hysteria
		[160452] = "Bloodlust", -- Netherwinds
		-- Healing
		[33206] = "PainSuppression",
		[62618] = "Barrier",
		[47788] = "GuardianSpirit",
		[64843] = "DivineHymn",
		[102342] = "Ironbark",
		[740] = "Tranquility",
		[6940] = "Sacrifice",
		[31821] = "DevotionAura",
		[98008] = "SpiritLink",
		[108280] = "HealingTide",
		[116849] = "LifeCocoon",
		[115310] = "Revival",
		[51052] = "AntiMagicZone",
		[76577] = "SmokeBomb",
		-- Test
		--[5697] = "Unending",
		--[21562] = "Unending"
}
combatLogMap.SPELL_CAST_START = {
		[160740] = "Feasts", -- Feast of Blood (+75)
		[160914] = "Feasts", -- Feast of the Waters (+75)
		[175215] = "Feasts", -- Savage Feast (+100)
	}
combatLogMap.SPELL_RESURRECT = {
		[20484] = "Rebirth", -- Rebirth
		[95750] = "Rebirth", -- Soulstone Resurrection
		[61999] = "Rebirth", -- Raise Ally
		[126393] = "Rebirth", -- Eternal Guardian (Hunter pet)
		[159931] = "Rebirth", -- Gift of Chi-Ji (Hunter pet)
		[159956] = "Rebirth", -- Dust of Life (Hunter pet)
}
combatLogMap.SPELL_HEAL = {
		[633] = "LayofHands", -- Pala Lay of Hands
}
combatLogMap.UNIT_SPELLCAST_SENT = {
		[2006] = "Ressing", -- Priest Resurrection
		[7328] = "Ressing", -- Pala Resurrection
}
combatLogMap.UNIT_SPELLCAST_SUCCEEDED = {
		[2006] = "RessingSucess", -- Priest Resurrection
		[7328] = "RessingSucess", -- Pala Resurrection
}
----------------------------------
-- INITIALIZATION
----------------------------------

local module = addon:NewModule("RaidAuras","AceEvent-3.0", "AceTimer-3.0")
addon.RaidAuras = module

local db,pfl
--local instance = false
local RaidAurasBarColor

function module:RefreshProfile() 
	pfl = db.profile

	if pfl.BarColor == "GLOBAL" then RaidAurasBarColor = addon.db.profile.Globals.GlobalBarCrl
	else RaidAurasBarColor = pfl.BarColor end	
	
	if not pfl.Enabled then
		--module:UnregisterEvent("GROUP_ROSTER_UPDATE")
		module:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
		module:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		addon.Alerts:QuashByPattern("^raidauras")
	elseif pfl.Enabled then
		--module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		if IsInInstance() then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end	
		--module:RegisterEvent("GROUP_ROSTER_UPDATE")
	end
end

function module:OnInitialize()
	self.db = addon.db:RegisterNamespace("RaidAuras", defaults)
	db = self.db
	pfl = db.profile

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")

	if pfl.BarColor == "GLOBAL" then RaidAurasBarColor = addon.db.profile.Globals.GlobalBarCrl
	else RaidAurasBarColor = pfl.BarColor end	
	
	if pfl.Enabled then
	--	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		--if not IsInInstance() or IsInInstance() == "none" then
			--instance = false
		--else
			--instance = true
		--	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		--end
		--self:RegisterEvent("GROUP_ROSTER_UPDATE")
		--self:GROUP_ROSTER_UPDATE()
	end
end

function module:AnnounceType(message)
	local channel
	
	if IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
		channel = "RAID_WARNING"
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		channel = "INSTANCE_CHAT"
	elseif IsInRaid() then
		channel = "RAID"
	elseif IsInGroup() then
		channel = "PARTY"
	else
		return
	end

	SendChatMessage("DXE: "..message, channel)
end

function module:AnnounceUtil(args)
	local spellId, nick, spellName = ("\t"):split(args)
	local message

	if pfl.PrintMsg then
		local ability = ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, GetSpellInfo(spellId))
		spellName = ability 
	end

	if nick == UnitName("player") then
		message = format("%s %s",L["I have laid down a"],spellName)
		if not pfl.PrintMsg then self:AnnounceType(message)
		else addon:Print(message) end
	else
		if pfl.AllPlayers then
			if not pfl.PrintMsg then 
				message = format("%s %s %s",nick:gsub("%-.+", "*"),L["has placed"],spellName)
				self:AnnounceType(message)
			else
				nick = getclasscolor(nick)
				message = format("%s|r|h %s %s",nick:gsub("%-.+", "*"),L["has placed"],spellName)
				addon:Print(message)
			end
		end
	end
end
function module:AnnounceSpell(args)
	local spellId, nick, spellName, seconds, target = ("\t"):split(args)
	local message

	if pfl.PrintMsg then
		local ability = ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, GetSpellInfo(spellId))
		spellName = ability
		colornick = getclasscolor(nick)
		if target then target = getclasscolor(target) end
	end

	if nick == UnitName("player") then
		if tonumber(seconds) ~= 0 and seconds ~= nil then
		    if target then
				if pfl.PrintMsg then message = format("%s %s %s %s|r|h (%ss)",L["I have cast"],spellName,L.alert["on"],target:gsub("%-.+", "*"),seconds)
				else message = format("%s %s %s %s (%ss)",L["I have cast"],spellName,L.alert["on"],target:gsub("%-.+", "*"),seconds) end
			else message = format("%s %s (%ss)",L["I have cast"],spellName,seconds) end
		else 
		    if target then
				if pfl.PrintMsg then message = format("%s %s %s %s",L["I have cast"],spellName,L.alert["on"],target:gsub("%-.+", "*"))
				else message = format("%s %s %s %s",L["I have cast"],spellName,L.alert["on"],target:gsub("%-.+", "*")) end
			else message = format("%s %s",L["I have cast"],spellName) end
		end
		if not pfl.PrintMsg then self:AnnounceType(message)
		else addon:Print(message) end
	else
		if pfl.AllPlayers then
			if tonumber(seconds) ~= 0 and seconds ~= nil then
				if target then
					if pfl.PrintMsg then message = format("%s|r|h %s %s %s %s|r|h (%ss)",colornick:gsub("%-.+", "*"),L["has cast"],spellName,L["on"],target:gsub("%-.+", "*"),seconds)
					else message = format("%s %s %s %s %s (%ss)",colornick:gsub("%-.+", "*"),L["has cast"],spellName,L["on"],target:gsub("%-.+", "*"),seconds) end
				else
					if pfl.PrintMsg then message = format("%s|r|h %s %s (%ss)",colornick:gsub("%-.+", "*"),L["has cast"],spellName,seconds)
					else message = format("%s %s %s (%ss)",colornick:gsub("%-.+", "*"),L["has cast"],spellName,seconds) end
				end
			else 
				if target then
					if pfl.PrintMsg then message = format("%s|r|h %s %s %s %s",colornick:gsub("%-.+", "*"),L["has cast"],spellName,L["on"],target:gsub("%-.+", "*"))
					else message = format("%s %s %s %s %s",colornick:gsub("%-.+", "*"),L["has cast"],spellName,L["on"],target:gsub("%-.+", "*")) end
				else
					if pfl.PrintMsg then message = format("%s|r|h %s %s",colornick:gsub("%-.+", "*"),L["has cast"],spellName)
					else message = format("%s %s %s",colornick:gsub("%-.+", "*"),L["has cast"],spellName) end
				end
			end
			if not pfl.PrintMsg then self:AnnounceType(message)
			else addon:Print(message) end
		end
	end
end

function module:SpellEnded(args)
	local spellId, nick, spellName, _, target = ("\t"):split(args)
	local message, colornick
	
	if pfl.PrintMsg then
		local ability = ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, GetSpellInfo(spellId))
		spellName = ability 
		colornick = getclasscolor(nick)
		if target then target = getclasscolor(target) end
	end

	if nick == UnitName("player") then
		 if target then
			if pfl.PrintMsg then message = format("%s %s %s|r|h %s",spellName,L.alert["on"],target:gsub("%-.+", "*"),L["has ended"])
			else message = format("%s %s %s %s",spellName,L.alert["on"],target:gsub("%-.+", "*"),L["has ended"]) end
		else message = format("%s %s",spellName,L["has ended"]) end
	else
		if pfl.AllPlayers then
			if target then
				if pfl.PrintMsg then message = format("%s|r|h %s %s %s|r|h %s",colornick:gsub("%-.+", "*"),spellName,L["on"],target:gsub("%-.+", "*"),L["has ended"])
				else message = format("%s %s %s %s %s",colornick:gsub("%-.+", "*"),spellName,L["on"],target:gsub("%-.+", "*"),L["has ended"]) end
			else 
				if pfl.PrintMsg then message = format("%s|r|h %s %s",colornick:gsub("%-.+", "*"),spellName,L["has ended"])
				else message = format("%s %s %s",colornick:gsub("%-.+", "*"),spellName,L["has ended"]) end
			end
			if not pfl.PrintMsg then self:AnnounceType(message)
			else addon:Print(message) end
		end
	end
end

local prev = 0
function module:Bloodlust(_, spellId, nick, spellName, event)
	if pfl.Bloodlust then
		local t = GetTime()
		if t-prev > 40 then
			if pfl.ChatMessages then
				local args = spellId.."\t"..nick.."\t"..spellName.."\t40"
				self:AnnounceSpell(args)
			end			
			nick = getclasscolor(nick)
			nick = nick:gsub("%-.+", "*")			
			if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 40, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[2825]) end
			if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[2825],pfl.sound) end
			prev = t
		end
	end
end
function module:Repair(_, spellId, nick, spellName)
	if pfl.Repair then

		SetMapToCurrentZone()
		local x,y = GetPlayerMapPosition(nick)

		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName
			self:AnnounceUtil(args)
		end	
		if pfl.Arrows then addon.Arrows:AddTarget(nick,6,"TOWARD",spellName,spellName,nil,true,x,y,1,5,20,nil) end
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		if spellId == 54711 and pfl.Bars then
			addon.Alerts:Auras("raidauras"..spellName,  nick.."|r|h: "..spellName, 300, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[54711])
		elseif spellId == 157066 and pfl.Bars then
			addon.Alerts:Auras("raidauras"..spellName,  nick.."|r|h: "..spellName, 300, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[157066])
		elseif spellId == 22700 and pfl.Bars then
			addon.Alerts:Auras("raidauras"..spellName,  nick.."|r|h: "..spellName, 600, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[22700])
		elseif spellId == 44389 and pfl.Bars then
			addon.Alerts:Auras("raidauras"..spellName,  nick.."|r|h: "..spellName, 600, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[44389])
		elseif spellId == 67826 and pfl.Bars then
			addon.Alerts:Auras("raidauras"..spellName,  nick.."|r|h: "..spellName, 660, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[67826])
		end	
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[29893],pfl.sound) end
	end
--nick,defn.persist,defn.action,defn.msg,defn.spell,stgs.sound,defn.fixed,
--									 defn.xpos,defn.ypos,defn.range1,defn.range2,defn.range3,defn.lockon)
end
function module:SummoningStone(_, spellId, nick, spellName)
	if pfl.SummoningStone then

		SetMapToCurrentZone()
		local x,y = GetPlayerMapPosition(nick)
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName
			self:AnnounceUtil(args)
		end	
		--local x,y = addon:GetDistanceToUnitSetFixed(nick)
		--print("SummoningStone",nick,x,y)	
		if pfl.Arrows then addon.Arrows:AddTarget(nick,6,"TOWARD",spellName,spellName,nil,true,x,y,1,5,20,nil) end
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[698]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[698],pfl.sound) end
	end
end
function module:Feasts(_, spellId, nick, spellName)
	if pfl.Feasts then

		SetMapToCurrentZone()
		local x,y = GetPlayerMapPosition(nick)
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName
			self:AnnounceUtil(args)
		end	
		--print("feast",nick,x,y)
		if pfl.Arrows then addon.Arrows:AddTarget("player",6,"TOWARD",spellName,spellName,nil,true,x,y,1,5,20,nil) end
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[160740]) end
	end	
end

function module:Soulwell(_, spellId, nick, spellName)
	if pfl.Soulwell then

		SetMapToCurrentZone()
		local x,y = GetPlayerMapPosition(nick)
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName
			self:AnnounceUtil(args)
		end	
		if pfl.Arrows then addon.Arrows:AddTarget(nick,6,"TOWARD",spellName,spellName,nil,true,x,y,1,5,20,nil) end
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 120, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[29893]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[29893],pfl.sound) end
	end
end
---------------------------------------------------------------------------------------
function module:RallyingCry(_, spellId, nick, spellName) -- Warrior
	if pfl.RallyingCry then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t10"
			self:ScheduleTimer("SpellEnded",10,args)
			self:AnnounceSpell(args)
		end		
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 10, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[97462])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[97462]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[97462],pfl.sound) end
	end
end

function module:StampedingRoar(_, spellId, nick, spellName, event)
	if pfl.StampedingRoar then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t8"
			self:ScheduleTimer("SpellEnded",8,args)
			self:AnnounceSpell(args)
		end		
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 8, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[106898])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 120, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[106898]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[106898],pfl.sound) end
	end
end
function module:SmokeBomb(_, spellId, nick, spellName)
	if pfl.SmokeBomb then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t5"
			self:ScheduleTimer("SpellEnded",5,args)
			self:AnnounceSpell(args)
		end		
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 5, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[76577])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[76577]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[76577],pfl.sound) end
	end
end
function module:PainSuppression(target, spellId, nick, spellName, event)
	if pfl.PainSuppression then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t8".."\t"..target
			self:ScheduleTimer("SpellEnded",8,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")		
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick.." -> "..target..": :"..spellName, 8, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[33206])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[33206]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[33206],pfl.sound) end
	end
end
function module:GuardianSpirit(target, spellId, nick, spellName, event)
	if pfl.GuardianSpirit then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t10".."\t"..target
			self:ScheduleTimer("SpellEnded",10,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")				
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick.." -> "..target..": :"..spellName, 10, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[47788])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[47788]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[47788],pfl.sound) end
	end
end
function module:Barrier(_, spellId, nick, spellName)
	if pfl.Barrier then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t10"
			self:ScheduleTimer("SpellEnded",10,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 10, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[62618])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[62618]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[62618],pfl.sound) end
	end
end
function module:DivineHymn(_, spellId, nick, spellName, event)
	if pfl.DivineHymn then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t8"
			self:ScheduleTimer("SpellEnded",8,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 8, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[64843])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[64843]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[64843],pfl.sound) end
	end
end

function module:Tranquility(_, spellId, nick, spellName, event)
	if pfl.Tranquility then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t8"
			self:ScheduleTimer("SpellEnded",8,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 8, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[740])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[740]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[740],pfl.sound) end
	end
end
function module:Ironbark(target, spellId, nick, spellName, event)
	if pfl.Ironbark then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t12".."\t"..target
			self:ScheduleTimer("SpellEnded",12,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")				
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick.." -> "..target..": :"..spellName, 12, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[102342]) end
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 60, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[102342]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[102342],pfl.sound) end
	end
end
function module:Sacrifice(target, spellId, nick, spellName, event)
	if pfl.Sacrifice then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t12".."\t"..target
			self:ScheduleTimer("SpellEnded",12,args)
			self:AnnounceSpell(args)
		end		
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")				
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick.." -> "..target..": :"..spellName, 12, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[6940]) end
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 120, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[6940]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[6940],pfl.sound) end
		end
end
function module:DevotionAura(_, spellId, nick, spellName, event)
	if pfl.DevotionAura then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t6"
			self:ScheduleTimer("SpellEnded",6,args)
			self:AnnounceSpell(args)
		end		
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 6, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[31821]) end
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[31821]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[31821],pfl.sound) end
	end
end
function module:SpiritLink(_, spellId, nick, spellName, event)
	if pfl.SpiritLink then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t6"
			self:ScheduleTimer("SpellEnded",6,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 6, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[98008])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[98008]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[98008],pfl.sound) end
	end
end
function module:HealingTide(_, spellId, nick, spellName, event)
	if pfl.HealingTide then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t10"
			self:ScheduleTimer("SpellEnded",10,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 10, 15, "DXE ALERT2", "MIDBLUE", "RED", nil, addon.ST[108280])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[108280]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[108280],pfl.sound) end
	end
end
function module:LifeCocoon(target, spellId, nick, spellName, event)
	if pfl.LifeCocoon then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t12"
			self:ScheduleTimer("SpellEnded",12,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")				
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick.." -> "..target..": :"..spellName, 12, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[116849])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 120, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[116849]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[116849],pfl.sound) end
	end
end
function module:Revival(_, spellId, nick, spellName, event)
	if pfl.Revival then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 180, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[115310]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[115310],"ALERT13") end
	end
end
function module:AntiMagicZone(_, spellId, nick, spellName, event)
	if pfl.AntiMagicZone then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t3"
			self:ScheduleTimer("SpellEnded",3,args)
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		--if pfl.Bars then addon.Alerts:Auras(spellName, nick..": "..spellName, 3, 15, "DXE ALERT2", RaidAurasBarColor, "RED", nil, addon.ST[51052])
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 120, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[51052]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName,pfl.color1,addon.ST[51052],pfl.sound) end
	end
end
function module:Rebirth(target, spellId, nick, spellName, event)
	if pfl.Rebirth then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t0".."\t"..target
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")				
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 600, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[20484]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[20484],pfl.sound) end
	end
end
function module:LayofHands(target, spellId, nick, spellName, event)
	if pfl.LayofHands then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t0".."\t"..target
			self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")
		if pfl.Bars then addon.Alerts:Auras("raidauras"..spellName, nick.."|r|h: "..spellName, 600, 15, "DXE ALERT2", RaidAurasBarColor, pfl.Flashcolor, nil, addon.ST[633]) end
		if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[633],pfl.sound) end
	end
end
function module:Ressing(target, spellId, nick, spellName, event)
	if pfl.Resurrection then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t0".."\t"..target
			print("Ressing",target)
			--self:AnnounceSpell(args)
		end	
		nick = getclasscolor(nick)
		nick = nick:gsub("%-.+", "*")
		target = getclasscolor(target)
		target = target:gsub("%-.+", "*")				
		--if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[20484],pfl.sound) end
	end
end
function module:RessingSucess(target, spellId, nick, spellName, event)
	if pfl.Resurrection then
		if pfl.ChatMessages then
			local args = spellId.."\t"..nick.."\t"..spellName.."\t0".."\t"..target
			print("Ressing",target,"was successfully")
		--	self:AnnounceSpell(args)
		end	
	--	nick = getclasscolor(nick)
	--	nick = nick:gsub("%-.+", "*")
	--	target = getclasscolor(target)
	--	target = nick:gsub("%-.+", "*")			
	--	if pfl.Messages then addon.Alerts:NewTMessage(nick.."|r|h: "..spellName.." "..L.alert["on"].." "..target,pfl.color1,addon.ST[20484],pfl.sound) end
	end
end
function module:COMBAT_LOG_EVENT_UNFILTERED(a, b, event, c, d, source, e, f, g, player, h, i, spellId, spellName)
		local f = combatLogMap[event] and combatLogMap[event][spellId] or nil
		if f and source then
			if event == "SPELL_CAST_SUCCESS" then
				self[f](self, player, spellId, source, spellName, event)
			else
				if pfl.exhealer and addon:IsHealer() then return true end
				if pfl.extank and addon:IsTank() then return true end
				if pfl.exdps and addon:IsDps() then return true end
				self[f](self, player, spellId, source, spellName, event)
			end
		end
end

function module:ZONE_CHANGED_NEW_AREA()
	if not IsInInstance() or IsInInstance() == "none" then
		--instance = false
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		--instance = true
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end