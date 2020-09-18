-- Auto Responder for whispers during encounters
--------------------------------------------

local addon = DXE
local L = addon.L

local ipairs, pairs = ipairs, pairs
local remove,wipe = table.remove,table.wipe
local match,len,format,split,find = string.match,string.len,string.format,string.split,string.find
local GetTime = GetTime

local NID = addon.NID
local CE
local AR = {}
local interval = 15
local MODS = {
	bigwigs = "^<BW>",
	dbm = "^<Deadly Boss Mods>",
	dbm2 = "^<DBM>",
	dxe = "^DXE Autoresponder",
} -- don't respond to addon whispers

local defaults = {
			enabled = false,
			whisperfilter = true
		}
local plugins_group = {}

----------------------------------
-- INITIALIZATION
----------------------------------

local module = addon:NewModule("AutoResponder","AceEvent-3.0")
addon.plugins.AutoResponder = module
local db,pfl

function module:RefreshProfile() pfl = db.profile end
local function genblank(order) return {type = "description", name = "", order = order} end

local function InitializeOptions()
	local AutoResponder = addon.AutoResponder
	local AR_group = {
		type = "group",
		name = L.options["Auto Responder"],
		get = function(info) return db.profile.Plugins.AutoResponder[info[#info]] end,
		set = function(info,v) db.profile.Plugins.AutoResponder[info[#info]] = v end,
		order = 400,
		args = {
			header = {
				type = "header",
				name = L.options["Auto Responder"],
				order = 1200,
			},
			desc = {
				type = "description",
				name = L.options["Activates the automatic responder for whispers during boss encounters and receive a short summary of the current fight (boss name, time elapsed, how many raid members are alive). The auto respnder works for normal and Battle.net whispers."],
				order = 1300,
				width = "full",
			},
			blank = genblank(1301),
			header = {
				type = "group",
				order = 1305,
				name = L.options["Settings"],
				inline = true,
				args = {				
					enabled = {
						type = "toggle",
						name = L.options["Enable Auto Responder"],
						order = 1400,
						width = "double",
					},
					blank2 = genblank(1500),
					whisperfilter = {
						type = "toggle",
						name = L.options["Enable Whisper Filter"],
						desc = L.options["This option filter the message dxestatus sent to player appearing to you, disable if you want to see it."],
						order = 1600,
						width = "double",
					},	
				},
			},			
		},
	}

	module.plugins_group = AR_group
end

function module:GetOptions()
	return module.plugins_group
end

function module:OnInitialize()
--	self.db = addon.db:RegisterNamespace("AutoResponder", defaults)

	db = addon.db
	if db.profile.Plugins.AutoResponder == nil then
		db.profile.Plugins.AutoResponder = defaults
	end
	
	module:RefreshProfile()

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")

	addon.RegisterCallback(self,"SetActiveEncounter","Set")	
	
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end	
	
	InitializeOptions()	
	
	addon.Options:RegisterPlugin(module)
end

---------------------------------------------
-- Chat Frame Filter
---------------------------------------------
function module:whisperfilter()

	local function BOSS_MOD_FILTER(self,event,msg)
		if type(msg) == "string" then
			for k,v in pairs(MODS) do
				if find(msg,v) then return true end
			end
		--	if find(msg,"^dxestatus") then return true end
		end
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", BOSS_MOD_FILTER)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", BOSS_MOD_FILTER)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", BOSS_MOD_FILTER)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", BOSS_MOD_FILTER)
end

---------------------------------------------
-- Encounter Load/Start/Stop
---------------------------------------------
function module:Set(_,data)
	if pfl.enabled then
		addon.RegisterCallback(self,"StartEncounter","Start")
		addon.RegisterCallback(self,"StopEncounter","Stop")
		if AR then wipe(AR) end
		CE = data
		AR.boss = CE.name
		--AR.msg = format(L["DXE Autoresponder: Currently fighting %s. Send \"dxestatus\" for details."],AR.boss)
		AR.throttle = {} -- who whispered us
	end
end
function module:Start(_,...)
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	if pfl.whisperfilter then self:whisperfilter() end
end

function module:Stop()
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER")

end

function module:RefreshProfile() pfl = db.profile.Plugins.AutoResponder end

addon:AddToRefreshProfile(RefreshProfile)

---------------------------------------------
-- Responder
---------------------------------------------
do
	local function helper()
		local elapsed = addon.Pane.timer.left:GetText()
		local alive = 0
		local percent = "n.a."
		local found = false
		local diff = select(4, GetInstanceInfo())

		for i = 1, GetNumGroupMembers() do
			alive = alive + ((UnitIsDeadOrGhost("raid"..i) and 0) or 1)
		end

		--local hp,hpmax = UnitHealth(AR.boss),UnitHealthMax(AR.boss)
		--if UnitExists("boss1") then
	--[[		for i=1, MAX_BOSS_FRAMES do
			--	print("Responder Debug",AR.boss,UnitName("boss"..i))
				if UnitExists("boss"..i) and UnitName("boss"..i) == AR.boss then
					--local healthRemaining = healthRemaining + UnitHealth("boss"..i)
					--local totalHealth = totalHealth + UnitHealthMax("boss"..i)
					--print("boss debug",string.format("%0.0f%%", healthRemaining/totalHealth * 100))
					local hp,hpmax = UnitHealth("boss"..i),UnitHealthMax("boss"..i)
					percent = hp / hpmax * 100
					found = true
				end
			end--]]
		--end
		--if not found and UnitExists("boss1") then
		if UnitExists("boss1") then
			local hp,hpmax = UnitHealth("boss1"),UnitHealthMax("boss1")
			--percent = hp / hpmax * 100
			percent = string.format("%0.0f%%", hp/hpmax * 100)
			if not AR.boss then AR.boss = UnitName("boss1") end
		end
		return elapsed,alive,percent,diff
	end

	local function send(recip, msg, realid)
		if realid then
			BNSendWhisper(recip, msg)
		else
			SendChatMessage(msg, "WHISPER", nil, recip)
		end
	end

	function module:responder(msg, sender, realid)
		for k,v in pairs(MODS) do
			if find(msg,v) then return true end
		end

		if not AR.throttle[sender] then
			AR.throttle[sender] = 0
		end

		if GetTime() > AR.throttle[sender]+interval then
			local dur,alive,percent,diff = helper()
			AR.status = string.format(L["DXE Autoresponder: Boss %s (%s), %s min elapsed, %s/%s alive, %s"],AR.boss,percent,dur,alive,GetNumGroupMembers(),diff)
			send(sender, AR.status, realid)
			AR.throttle[sender] = GetTime()
		end
		--[[if find(msg,"^dxestatus") then
			local dur,alive,percent = helper()
			AR.status = format(L["DXE Autoresponder: Boss %s (%s%%), %s min elapsed, %s/%s alive"],AR.boss,percent,dur,alive,GetNumGroupMembers())
			send(sender, AR.status, realid)
		else
			if GetTime() > AR.throttle[sender]+interval then
				send(sender, AR.msg, realid)
				AR.throttle[sender] = GetTime()
			end
		end--]]
	end
end

---------------------------------------------
-- Events
---------------------------------------------
do
	function module:CHAT_MSG_WHISPER(_, msg, sender, _, _, _, target)
		if target ~= "GM" then
			sender = Ambiguate(sender, "none")
			self:responder(msg, sender, false)
		end
	end

	function module:CHAT_MSG_BN_WHISPER(_, msg, ...)
		local realid = select(12, ...)
		self:responder(msg, realid, true)
	end
end
