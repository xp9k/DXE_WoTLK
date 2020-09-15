--[[
	The contents of this file are auto-generated using the WoWAce localization application
	Please go to http://www.wowace.com/projects/deus-vox-encounters/localization/ to update translations.
	Anyone with a wowace/curseforge account can edit them. 
]] 

local AL = LibStub("AceLocale-3.0")

local silent = true

local L = AL:NewLocale("DXE", "enUS", true, silent)

if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "enUS", true, silent)
AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Plugins
local Plugins = AL:NewLocale("DXE Plugins", "enUS", true, silent)
AL:GetLocale("DXE").Plugins = AL:GetLocale("DXE Plugins")

if GetLocale() == "enUS" or GetLocale() == "enGB" then return end
end


local L = AL:NewLocale("DXE", "ruRU")
if L then
--	Plugins
local Plugins = AL:NewLocale("DXE Plugins", "ruRU")
Plugins["Plugins"] = "Расширения"
Plugins["LFG Invitation"] = "Приглашение в подземелье"

--	Flump
Plugins["bot"]	 = "%s%s ставит %s!"
Plugins["used"]	 = "%s%s использовал(а) %s!"
Plugins["sw"]	 = "%s заканчивается на %s%s!"
Plugins["cast"]	 = "%s%s применяет %s на %s%s!"
Plugins["fade"]	 = "На %s%s заканчивается %s от %s%s!"
Plugins["feast"]  = "%s%s готовит %s!"
Plugins["gs"]	 = "%s%s's %s прокнул: %d отлечено!"
Plugins["ad"]	 = "%s%s's %s consumed!"
Plugins["res"]	 = "%s%s применяет %s на %s%s!"
Plugins["portal"] = "%s%s открыл(а) %s!"
Plugins["create"] = "%s%s создал(а) %s!"
Plugins["dispel"] = "%s%s's %s failed to dispel %s%s's %s!"
Plugins["ss"]	 = "%s умер с %s!"
Plugins["miscellaneous"] = "%s применяет %s"

--	Plugins Options
Plugins["Automatically accept ReadyCheck"] = "Автоматически принимать проверку готовности"
Plugins["Automatically reply for whisps while boss Encounter"] = "Автоматически отвечать на личные сообщения при битве с боссами"
Plugins["Intercept DBM Pull and Puzza Timers"] = "Перехватывать сообщения DBM для Перерыва и Пулла"
Plugins["|cffff2020Auto-accepted a Ready Check at |r"] = "|cffff2020Автоподтверждение готовности сработало в |r"
Plugins["%s is in combat with %s"] = "%s Сейчас не может ответить. Он в бою с %s"

AL:GetLocale("DXE").Plugins = AL:GetLocale("DXE Plugins")

return
end