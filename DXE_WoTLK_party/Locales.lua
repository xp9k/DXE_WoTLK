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
local chat_wotlk_party = AL:NewLocale("DXE Chat WoTLK Party", "enUS", true, silent)
AL:GetLocale("DXE").chat_wotlk_party = AL:GetLocale("DXE Chat WoTLK Party")
-- NPC names
local npc_wotlk_party = AL:NewLocale("DXE NPC WoTLK Party", "enUS", true, silent)
AL:GetLocale("DXE").npc_wotlk_party = AL:GetLocale("DXE NPC WoTLK Party")
if GetLocale() == "enUS" or GetLocale() == "enGB" then return end
end



local L = AL:NewLocale("DXE", "ruRU")
if L then

-- Chat triggers
local chat_wotlk_party = AL:NewLocale("DXE Chat WoTLK Party", "ruRU")

chat_wotlk_party["^Finally, a captive audience!"] = "^Наконец-то гости пожаловали!"
chat_wotlk_party["^You dare look upon the host of souls?"] = "^Вы осмелились взглянуть на вместилище душ?"
chat_wotlk_party["^Alas, brave, brave adventurers"] = "^Увы, бесстрашные герои"

AL:GetLocale("DXE").chat_wotlk_party = AL:GetLocale("DXE Chat WoTLK Party")

-- NPC names
local npc_wotlk_party = AL:NewLocale("DXE NPC WoTLK Party", "ruRU")
npc_wotlk_party["Bronjahm"] = "Броньям"
npc_wotlk_party["Devourer of Souls"] = "Пожиратель Душ"
npc_wotlk_party["Tyrannus"] = "Тираний"

AL:GetLocale("DXE").npc_wotlk_party = AL:GetLocale("DXE NPC WoTLK Party")
return
end
