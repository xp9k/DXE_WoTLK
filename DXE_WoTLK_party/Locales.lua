--[[
	The contents of this file are auto-generated using the WoWAce localization application
	Please go to http://www.wowace.com/projects/deus-vox-encounters/localization/ to update translations.
	Anyone with a wowace/curseforge account can edit them. 
]] 

local AL = LibStub("AceLocale-3.0")

local silent = true

local L = AL:NewLocale("DXE", "enUS", true, silent)
if L then

-- Chat triggers
local chat_5ppl = AL:NewLocale("DXE Chat 5ppl", "enUS", true, silent)
AL:GetLocale("DXE").chat_5ppl = AL:GetLocale("DXE Chat 5ppl")
-- NPC names
local npc_5ppl = AL:NewLocale("DXE NPC 5ppl", "enUS", true, silent)
AL:GetLocale("DXE").npc_5ppl = AL:GetLocale("DXE NPC 5ppl")
if GetLocale() == "enUS" or GetLocale() == "enGB" then return end
end

local L = AL:NewLocale("DXE", "ruRU")
if L then

-- Chat triggers
local chat_5ppl = AL:NewLocale("DXE Chat 5ppl", "ruRU")

chat_5ppl["5ppl"] = "Подземелья"

chat_5ppl["^Finally"] = "^Наконец"
chat_5ppl["Corrupt Soul"] = "Оскверненная душа"

AL:GetLocale("DXE").chat_5ppl = AL:GetLocale("DXE Chat 5ppl")

-- NPC names
local npc_5ppl = AL:NewLocale("DXE NPC 5ppl", "ruRU")
npc_5ppl["Bronjahm"] = "Броньям"

AL:GetLocale("DXE").npc_5ppl = AL:GetLocale("DXE NPC 5ppl")
return
end
