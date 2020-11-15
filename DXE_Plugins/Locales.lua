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
Plugins["Plugs"] = "Свистелки-перделки"
Plugins["Auto Responder"] = "Авто-ответчик"
Plugins["LFG Invitation"] = "Приглашение в подземелье"
Plugins["Settings"] = "Настройки"

--	Flump
Plugins["bot"]	 = "%s%s поставил %s!"
Plugins["used"]	 = "%s%s использовал %s!"
Plugins["sw"]	 = "%s заканчивается на %s%s!"
Plugins["cast"]	 = "%s%s применил %s на %s%s!"
Plugins["fade"]	 = "На %s%s заканчивается %s от %s%s!"
Plugins["feast"]  = "%s%s приготовил %s!"
Plugins["gs"]	 = "У %s%s прокнул %s: %d отлечено!"
Plugins["ad"]	 = "%s%s's %s consumed!"
Plugins["res"]	 = "%s%s применил %s на %s%s!"
Plugins["portal"] = "%s%s открыл %s!"
Plugins["create"] = "%s%s создал %s!"
Plugins["dispel_failed"] = "%s%s's %s failed to dispel %s%s's %s!"
Plugins["dispels"] = "%s%s сдипелила %s с %s%s!"
Plugins["ss"]	 = "%s умер с %s!"
Plugins["miscellaneous"] = "%s применил %s"

Plugins["bot_fem"]	 = "%s%s поставила %s!"
Plugins["used_fem"]	 = "%s%s использовала %s!"
Plugins["sw_fem"]	 = "%s заканчивается на %s%s!"
Plugins["cast_fem"]	 = "%s%s применила %s на %s%s!"
Plugins["fade_fem"]	 = "На %s%s заканчивается %s от %s%s!"
Plugins["feast_fem"]  = "%s%s приготовила %s!"
Plugins["gs_fem"]	 = "У %s%s прокнул %s: %d отлечено!"
Plugins["ad_fem"]	 = "%s%s's %s consumed!"
Plugins["res_fem"]	 = "%s%s применила %s на %s%s!"
Plugins["portal_fem"] = "%s%s открыла %s!"
Plugins["create_fem"] = "%s%s создала %s!"
Plugins["dispel_failed_fem"] = "%s%s's %s failed to dispel %s%s's %s!"
Plugins["dispels"] = "%s%s сдипелил %s с %s%s!"
Plugins["ss_fem"]	 = "%s умерла с %s!"
Plugins["miscellaneous_fem"] = "%s применила %s"

Plugins["Use"] = "Защитные КД"
Plugins["Spells"] = "Поддержка"
Plugins["Rituals"] = "Ритуалы"
Plugins["Trinkets"] = "Тринкеты"
Plugins["Feasts"] = "Пиры"
Plugins["Misc"] = "Разное"
Plugins["Bots"] = "Боты"
Plugins["Portals"] = "Порталы"
Plugins["Bonus"] = "Бонус доспехов"
Plugins["Special"] = "Особое"
Plugins["Dispels"] = "Диспелы"

--	Plugins Options
Plugins["NONE"] = "НЕТ"
Plugins["SELF"] = "Себе"
Plugins["PARTY"] = "Группа"
Plugins["RAID"] = "Рейд"
Plugins["CHANNEL"] = "Канал"

Plugins["Enable %s"] = "Включить %s"
Plugins["Flump messages enabled"] = "Включить сообщения Flump"
Plugins["Channel"] = "Канал"
Plugins["Enable Flump messages"] = "Выводить сообщения Flump"
Plugins["Enable Fatality messages"] = "Выводить сообщения Fatality"
Plugins["Channel"] = "Канал вывода"
Plugins["combat"] = "Только в бою"
Plugins["Only in combat"] = "Показывать сообщения только в бою"
Plugins["only_tanks"] = "Только танки"
Plugins["Only tanks"] = "Показывать сообщения только от танков"
Plugins["Automatically accept ReadyCheck"] = "Автоматически принимать проверку готовности"
Plugins["Automatically take screenshots when achieve has earned"] = "Автоматически делать скриншот, когда получено достижение"
Plugins["Intercept DBM Pull and Puzza Timers"] = "Перехватывать сообщения DBM для Перерыва и Пулла"
Plugins["|cffff2020Auto-accepted a Ready Check at |r"] = "|cffff2020Автоподтверждение готовности сработало в |r"
Plugins["%s is in combat with %s"] = "%s Сейчас не может ответить. Он в бою с %s"
Plugins["Activates the automatic responder for whispers during boss encounters and receive a short summary of the current fight (boss name, time elapsed, how many raid members are alive)."] = "Активирует автоматический ответ на личные сообщения во время встречи с боссом и отправку краткой информации о текущем бою (имя босса, прошедшее время, количество живых участников рейда)."
Plugins["Enable Auto Responder"] = "Включить авто-ответчик"
Plugins["Enable Whisper Filter"] = "Включить фильтр Личных сообщений"
Plugins["This option filter the message dxestatus sent to player appearing to you, disable if you want to see it."] = "Эта опция фильтрует сообщение, отправленное игроку. Отключите, если хотите его видеть."

--	Fatality
Plugins["Number of deaths to report per combat session (default: 10)"] = "Количество смертей в отчете за бой (По умолчанию: 10)"
Plugins["Channel name"] = "Название канала"
Plugins["Fatality_OVERKILL"] = "Избыточный урон"
Plugins["Fatality_RAID_ICONS"] = "Рейдовые иконки"
Plugins["Short Nnumbers (i.e. 9431 = 9.4k)"] = "Сокращенные числа (Напр. 9431 = 9.4k)"
Plugins["Name of the channel to report to (note: OUTPUT must be set to CHANNEL)"] = "Название канала для отчета (Вывод должен быть установлен в Канал)"
Plugins["Number of damage events to report per person (default: 1)"] = "Количество событий для отчета на игрока (По умолчанию: 1)"
Plugins["Only in raid"] = "Только в рейде"
Plugins["Show death only in raid"] = "Показывать смерти только в рейде"

--	Helper
Plugins["Helper"] = "Помощник"
Plugins["Some helpful options"] = "Несколько полезных фишек"
Plugins["Enable Lady Helper"] = "Включить помощника на Леди"
Plugins["Puts off weapons before Mind Control"] = "Снимать оружие за 2 секунды до контроля"
Plugins["Enable Lanathel bites announces to the Raid channel"] = "Сообщать в рейд кто кого кусает на Ланатели"
Plugins["Announce when dispelled Plague jumps to another Raid Member"] = "Сообщать в рейд, если чума перекинулась на игрока при диспеле Чумы на Личе"
Plugins["Plague jumped to %s"] = "Чума перекинулась на %s"
Plugins["%s bites %s"] = "%s кусает %s"

AL:GetLocale("DXE").Plugins = AL:GetLocale("DXE Plugins")

return
end
