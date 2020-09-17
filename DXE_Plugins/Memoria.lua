-------------------------------------------------------------------------------
-- Memoria Declaration
--

local addon,L = DXE,DXE.L
local CE

local memoria = CreateFrame("Frame")
local db = addon.db
local pfl

local module = addon:NewModule("Memoria")
addon.Memoria = module

local Options = nil
local plugins_group = {}

local defaults = {
	profile = {
		Memoria = false
		},
}


----------------------------
--  Variables and Locals  --
----------------------------
memoria.ADDONNAME = "Memoria"
memoria.ADDONVERSION = GetAddOnMetadata(memoria.ADDONNAME, "Version");
memoria.BattlefieldScreenshotAlreadyTaken = false
memoria.Debug = nil
local deformat = LibStub("LibDeformat-3.0")


-----------------------
--  Default Options  --
-----------------------
memoria.DefaultOptions = {
    achievements = true,
    arenaEnding = false,
    arenaEndingOnlyWins = false,
    battlegroundEnding = false,
    battlegroundEndingOnlyWins = false,
    reputationChange = true,
    reputationChangeOnlyExalted = false,
    levelUp = true,
    version = 1,
}

local function InitializeOptions()
	if not addon.Options then
		if select(6,GetAddOnInfo("DXE_Options")) == "MISSING" then addon:Print((L["Missing %s"]):format("DXE_Options")) return end
		if not IsAddOnLoaded("DXE_Options") then addon.Loader:Load("DXE_Options") end
	end	
	local MemoriaArgs = {
		type = "group",
		name = L.Plugins["Memoria"],
		order = 10,
		args = {
				Memoria = {
					type = "toggle",
					name = L.Plugins["Enable Memoria"],
					order = 10,
					width = "full",
					get = function(info) return db.profile.Plugins[info[#info]] end,
					set = function(info,v) db.profile.Plugins[info[#info]] = v; module:RefreshProfile() end,
				},
		},
	}
	module.plugins_group = MemoriaArgs
	
end

----------------------------
--  Declare EventHandler  --
----------------------------
function Memoria:EventHandler(frame, event, ...)
    if (event == "ADDON_LOADED") then
        local addonName = ...
        if (addonName == memoria.ADDONNAME) then
            Memoria:ADDON_LOADED_Handler(frame)
        end
    
    elseif (event == "ACHIEVEMENT_EARNED") then
        Memoria:ACHIEVEMENT_EARNED_Handler()
    
    elseif (event == "CHAT_MSG_SYSTEM") then
        Memoria:DebugMsg("CHAT_MSG_SYSTEM_Handler() called...")
        Memoria:CHAT_MSG_SYSTEM_Handler(...)
    
    elseif (event == "PLAYER_LEVEL_UP") then
        Memoria:PLAYER_LEVEL_UP_Handler()
        
    elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
        Memoria:UPDATE_BATTLEFIELD_STATUS_Handler()
    
    end
end

function Memoria:ADDON_LOADED_Handler(frame)
    Memoria:Initialize(frame)
    Memoria:RegisterEvents(frame)
end

function Memoria:ACHIEVEMENT_EARNED_Handler()
    Memoria:DebugMsg("ACHIEVEMENT_EARNED_Handler() called...")
    if (not Memoria_Options.achievements) then return; end
    Memoria:AddScheduledScreenshot(1)
    Memoria:DebugMsg("Achievement - Added screenshot to queue")
end

function Memoria:CHAT_MSG_SYSTEM_Handler(...)
    if (not Memoria_Options.reputationChange) then return; end
    local chatmsg = ...
    local repLevel, faction = deformat(chatmsg, FACTION_STANDING_CHANGED)
    if (not repLevel or not faction) then return; end
    if (not Memoria_Options.reputationChangeOnlyExalted) then
        Memoria:AddScheduledScreenshot(1)
        Memoria:DebugMsg("Reputation level changed - Added screenshot to queue")
    else
        if (repLevel == FACTION_STANDING_LABEL8 or repLevel == FACTION_STANDING_LABEL8_FEMALE) then
            Memoria:AddScheduledScreenshot(1)
            Memoria:DebugMsg("Reputation level reached exalted - Added screenshot to queue")
        end
    end
end

function Memoria:PLAYER_LEVEL_UP_Handler()
    Memoria:DebugMsg("PLAYER_LEVEL_UP_Handler() called...")
    if (not Memoria_Options.levelUp) then return; end
    Memoria:AddScheduledScreenshot(1)
    Memoria:DebugMsg("Level up - Added screenshot to queue")
end

function Memoria:UPDATE_BATTLEFIELD_STATUS_Handler()
    Memoria:DebugMsg("UPDATE_BATTLEFIELD_STATUS_Handler() called...")
    -- if not activated, return
    if (not Memoria_Options.battlegroundEnding and not Memoria_Options.arenaEnding) then return; end
    -- if not ended, return
    local winner = GetBattlefieldWinner()                                                                             -- possible values: nil (no winner yet), 0 (Horde / green Team), 1 (Alliance / gold Team)
    if (winner == nil) then 
        memoria.BattlefieldScreenshotAlreadyTaken = false
        return
    end
    -- if screenshot of this battlefield already taken, then return
    if (memoria.BattlefieldScreenshotAlreadyTaken) then return; end
    -- if we are here, we have a freshly finished arena or battleground
    local isArena = IsActiveBattlefieldArena()
    if (isArena) then
        if (not Memoria_Options.arenaEnding) then return; end
        if (not Memoria_Options.arenaEndingOnlyWins) then
            Memoria:AddScheduledScreenshot(1)
            memoria.BattlefieldScreenshotAlreadyTaken = true
            Memoria:DebugMsg("Arena ended - Added screenshot to queue")
        else
            local playerTeam = Memoria:GetPlayerTeam()
            if (winner == playerTeam) then
                Memoria:AddScheduledScreenshot(1)
                memoria.BattlefieldScreenshotAlreadyTaken = true
                Memoria:DebugMsg("Arena won - Added screenshot to queue")
            end
        end
    else
        if (not Memoria_Options.battlegroundEnding) then return; end
        if (not Memoria_Options.battlegroundEndingOnlyWins) then
            Memoria:AddScheduledScreenshot(1)
            memoria.BattlefieldScreenshotAlreadyTaken = true
            Memoria:DebugMsg("Battleground ended - Added screenshot to queue")
        else
            local playerFaction = UnitFactionGroup("player")                                                          -- playerFaction is either "Alliance" or "Horde"
            if ( (playerFaction == "Alliance" and winner == 1) or (playerFaction == "Horde" and winner == 0) ) then
                Memoria:AddScheduledScreenshot(1)
                memoria.BattlefieldScreenshotAlreadyTaken = true
                Memoria:DebugMsg("Battleground won - Added screenshot to queue")
            end
        end
    end
end


----------------------------------------------
--  Update saved data and initialize addon  --
----------------------------------------------
function Memoria:Initialize(frame)
    if (not Memoria_Options) then
        Memoria_Options = {}
        for key, val in pairs(memoria.DefaultOptions) do
            Memoria_Options[key] = val
        end
    end
    Memoria:OptionsInitialize()
    Memoria:RegisterEvents(frame)
end


-------------------------------------------------
--  Set registered Event according to options  --
-------------------------------------------------
function Memoria:RegisterEvents(frame)
    frame:UnregisterAllEvents()
    if (Memoria_Options.achievements) then frame:RegisterEvent("ACHIEVEMENT_EARNED"); end
    if (Memoria_Options.reputationChange) then frame:RegisterEvent("CHAT_MSG_SYSTEM"); end
    if (Memoria_Options.levelUp) then frame:RegisterEvent("PLAYER_LEVEL_UP"); end
    if (Memoria_Options.arenaEnding or Memoria_Options.battlegroundEnding) then frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS"); end
end


--------------------------------------------------------
--  Create Frame for Events and ScreenshotScheduling  --
--------------------------------------------------------
MemoriaFrame = CreateFrame("Frame", "MemoriaFrame", UIParent, nil)
MemoriaFrame:SetScript("OnEvent", function(self, event, ...) Memoria:EventHandler(self, event, ...); end)
MemoriaFrame:RegisterEvent("ADDON_LOADED")
MemoriaFrame.queue = {}


-----------------------------------------
--  Functions for screenshot handling  --
-----------------------------------------
function Memoria:ScreenshotHandler(frame)
    if ( (time() - frame.lastCheck) == 0 ) then return; end
    local rmList = {}
    local now = time()
    local lastCheckInSecs = now - frame.lastCheck
    for i, delay in ipairs(frame.queue) do
        if (delay > 0) then
            frame.queue[i] = delay - lastCheckInSecs
        else
            if (now ~= frame.lastScreenshot) then
                Screenshot()
            end
            frame.lastScreenshot = now
            tinsert(rmList, i, 1)
        end
    end
    for i, index in ipairs(rmList) do
        tremove(frame.queue, index)
    end
    if (#frame.queue == 0) then
        frame:SetScript("OnUpdate", nil)
        frame.running = false
    end
    frame.lastCheck = now
end

function Memoria:AddScheduledScreenshot(delay)
    tinsert(MemoriaFrame.queue, delay);
    if (not MemoriaFrame.running) then
        MemoriaFrame.lastCheck = time()
        MemoriaFrame.lastScreenshot = time()
        MemoriaFrame.running = true
        MemoriaFrame:SetScript("OnUpdate", function(self) Memoria:ScreenshotHandler(self); end)
    end
end

function module:GetOptions()
	return module.plugins_group
end

function module:OnInitialize()	
	self.db = addon.db:RegisterNamespace("Memoria", defaults)
	db = addon.db
	pfl = db.profile

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")

	InitializeOptions()
	print("Memoria init")	
	addon.Options:RegisterPlugin(module)
end

function module:RefreshProfile() pfl = db.profile.Plugins end

addon:AddToRefreshProfile(RefreshProfile)

-------------------------
--  Support functions  --
-------------------------
function Memoria:GetPlayerTeam()
    local numBattlefieldScores = GetNumBattlefieldScores()
    local playerName = UnitName("player")
    for i = 1, numBattlefieldScores do
        local name, _, _, _, _, team = GetBattlefieldScore(i)
        if (playerName == team) then
            return team
        end
    end
end

function Memoria:DebugMsg(text)
    if (memoria.Debug) then
        DEFAULT_CHAT_FRAME:AddMessage("Memoria v."..memoria.ADDONVERSION.." Debug: "..text, 1, 0.5, 0);
    end
end
