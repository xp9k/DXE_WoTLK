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
-- Loader
local loader = AL:NewLocale("DXE Loader", "enUS", true, silent)
AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

if GetLocale() == "enUS" or GetLocale() == "enGB" then return end
end

local L = AL:NewLocale("DXE", "deDE")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "deDE")
zone["Citadel"] = "Zitadelle"
zone["Coliseum"] = "Kolosseum"
zone["Icecrown Citadel"] = "Eiskronenzitadelle"
zone["Kalimdor"] = "Kalimdor"
zone["Naxxramas"] = "Naxxramas"
zone["Northrend"] = "Nordend"
zone["Onyxia's Lair"] = "Onyxias Hort"
zone["The Eye of Eternity"] = "Das Auge der Ewigkeit"
zone["The Obsidian Sanctum"] = "Das Obsidiansanktum"
zone["The Ruby Sanctum"] = "Das Rubinsanktum"
zone["Trial of the Crusader"] = "Prüfung des Kreuzfahrers"
zone["Ulduar"] = "Ulduar"
zone["Vault of Archavon"] = "Archavons Kammer"
zone["WoTLK_party"] = "WoTLK party"


AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "deDE")
loader["|cffffff00Click|r to load"] = " |cffffff00Klicken|r, zum Laden"
loader["|cffffff00Click|r to toggle the settings window"] = "|cffffff00Klicken|r, um das Einstellungsfenster anzuzeigen"
loader["Deus Vox Encounters"] = "Deus Vox Encounters"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "esES")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "esES")
zone["Citadel"] = "Ciudadela"
zone["Coliseum"] = "Coliseo"
zone["Icecrown Citadel"] = "Ciudadela de la Corona de Hielo"
zone["Kalimdor"] = "Kalimdor"
zone["Naxxramas"] = "Naxxramas"
zone["Northrend"] = "Rasganorte"
zone["Onyxia's Lair"] = "Guarida de Onyxia"
zone["The Eye of Eternity"] = "El Ojo de la Eternidad"
zone["The Obsidian Sanctum"] = "El Sagrario Obsidiana"
zone["The Ruby Sanctum"] = "El Sagrario Rubí"
zone["Trial of the Crusader"] = "Prueba del Cruzado"
zone["Ulduar"] = "Ulduar"
zone["Vault of Archavon"] = "La Cámara de Archavon"

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "esES")
loader["|cffffff00Click|r to load"] = "|cffffff00Click|r para cargar"
loader["|cffffff00Click|r to toggle the settings window"] = "|cffffff00Click|r para mostrar la ventana de opciones"
loader["Deus Vox Encounters"] = "Deus Vox Encounters"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "esMX")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "esMX")
-- zone["Citadel"] = ""
-- zone["Coliseum"] = ""
-- zone["Icecrown Citadel"] = ""
-- zone["Kalimdor"] = ""
zone["Naxxramas"] = "Naxxramas"
-- zone["Northrend"] = ""
-- zone["Onyxia's Lair"] = ""
zone["The Eye of Eternity"] = "El Ojo de la Eternidad"
zone["The Obsidian Sanctum"] = "El Sagrario Obsidiana"
-- zone["The Ruby Sanctum"] = ""
-- zone["Trial of the Crusader"] = ""
-- zone["Ulduar"] = ""
-- zone["Vault of Archavon"] = ""

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "esMX")
-- loader["|cffffff00Click|r to load"] = ""
-- loader["|cffffff00Click|r to toggle the settings window"] = ""
-- loader["Deus Vox Encounters"] = ""

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "frFR")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "frFR")
zone["Citadel"] = "Citadelle"
zone["Coliseum"] = "Colisée"
zone["Icecrown Citadel"] = "Citadelle de la Couronne de glace"
zone["Kalimdor"] = "Kalimdor"
zone["Naxxramas"] = "Naxxramas"
zone["Northrend"] = "Norfendre"
zone["Onyxia's Lair"] = "Repaire d'Onyxia"
zone["The Eye of Eternity"] = "L'Œil de l'éternité"
zone["The Obsidian Sanctum"] = "Le sanctum Obsidien"
zone["The Ruby Sanctum"] = "Le sanctum Rubis"
zone["Trial of the Crusader"] = "L'épreuve du croisé"
zone["Ulduar"] = "Ulduar"
zone["Vault of Archavon"] = "Caveau d'Archavon"

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "frFR")
loader["|cffffff00Click|r to load"] = "|cffffff00Clic gauche|r pour charger."
loader["|cffffff00Click|r to toggle the settings window"] = "|cffffff00Clic gauche|r pour afficher/cacher la fenêtre des paramètres."
loader["Deus Vox Encounters"] = "Deus Vox Encounters"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "koKR")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "koKR")
zone["Citadel"] = "얼음왕관 성채"
zone["Coliseum"] = "원형경기장"
zone["Icecrown Citadel"] = "얼음왕관 성채"
zone["Kalimdor"] = "칼림도어"
zone["Naxxramas"] = "낙스라마스"
zone["Northrend"] = "노스렌드"
zone["Onyxia's Lair"] = "오닉시아의 둥지"
zone["The Eye of Eternity"] = "영원의 눈"
zone["The Obsidian Sanctum"] = "흑요석 성소"
zone["The Ruby Sanctum"] = "루비 성소"
zone["Trial of the Crusader"] = "십자군의 시험장"
zone["Ulduar"] = "울두아르"
zone["Vault of Archavon"] = "아카본 석실"

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "koKR")
loader["|cffffff00Click|r to load"] = "불러 오려면 |cffffff00클릭|r "
loader["|cffffff00Click|r to toggle the settings window"] = "설정 창을 열거나 닫으려면 |cffffff00클릭|r "
loader["Deus Vox Encounters"] = "Deus Vox Encounters"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "ruRU")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "ruRU")
zone["Citadel"] = "Цитадель Ледяной Короны"
zone["Coliseum"] = "Колизей"
zone["Icecrown Citadel"] = "Цитадель Ледяной Короны"
zone["Kalimdor"] = "Калимдор"
zone["Naxxramas"] = "Наксрамас"
zone["Northrend"] = "Нордскол"
zone["Onyxia's Lair"] = "Логово Ониксии"
zone["The Eye of Eternity"] = "Око Вечности"
zone["The Obsidian Sanctum"] = "Обсидиановое святилище"
zone["The Ruby Sanctum"] = "Рубиновое святилище"
zone["Ruby"] = "Рубиновое Святилище"
zone["Trial of the Crusader"] = "Испытание крестоносца"
zone["Ulduar"] = "Ульдуар"
zone["Vault of Archavon"] = "Склеп Аркавона"
zone["WoTLK Party"] = "Поздемелья WoTLK"
zone["WoTLK_party"] = "Поздемелья WoTLK"
zone["The Forge of Souls"] = "Кузня Душ"
zone["Pit of Saron"] = "Яма Сарона"

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "ruRU")
loader["|cffffff00Click|r to load"] = " |cffffff00Кликните|r для загрузки"
loader["|cffffff00Click|r to toggle the settings window"] = " |cffffff00Кликните|r для показа окна настроек"
loader["Deus Vox Encounters"] = "Deus Vox Encounters"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "zhCN")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "zhCN")
zone["Citadel"] = "堡垒" -- Needs review
zone["Coliseum"] = "银色竞技场"
zone["Icecrown Citadel"] = "冰冠堡垒"
zone["Kalimdor"] = "卡利姆多"
zone["Naxxramas"] = "纳克萨玛斯"
zone["Northrend"] = "诺森德"
zone["Onyxia's Lair"] = "奥妮克希亚的巢穴"
zone["The Eye of Eternity"] = "永恒之眼"
zone["The Obsidian Sanctum"] = "黑曜石圣殿"
zone["The Ruby Sanctum"] = "The Ruby Sanctum" -- Needs review
zone["Trial of the Crusader"] = "十字军试炼"
zone["Ulduar"] = "奥杜尔"
zone["Vault of Archavon"] = "阿尔卡冯的宝库"

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "zhCN")
loader["|cffffff00Click|r to load"] = "|cffffff00点击|r加载"
loader["|cffffff00Click|r to toggle the settings window"] = "|cffffff00点击|r切换设置窗口"
loader["Deus Vox Encounters"] = "Deus Vox 战斗警报"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end

local L = AL:NewLocale("DXE", "zhTW")
if L then

-- Zone names
local zone = AL:NewLocale("DXE Zone", "zhTW")
zone["Citadel"] = "冰冠城塞"
zone["Coliseum"] = "銀白競技場"
zone["Icecrown Citadel"] = "冰冠城塞"
zone["Kalimdor"] = "卡林多"
zone["Naxxramas"] = "納克薩瑪斯"
zone["Northrend"] = "北裂境"
zone["Onyxia's Lair"] = "奧妮克希亞的巢穴"
zone["The Eye of Eternity"] = "永恆之眼"
zone["The Obsidian Sanctum"] = "黑曜聖所"
zone["The Ruby Sanctum"] = "晶紅聖所"
zone["Trial of the Crusader"] = "十字軍試煉"
zone["Ulduar"] = "奧杜亞"
zone["Vault of Archavon"] = "亞夏梵穹殿"

AL:GetLocale("DXE").zone = AL:GetLocale("DXE Zone")
-- Loader
local loader = AL:NewLocale("DXE Loader", "zhTW")
loader["|cffffff00Click|r to load"] = "|cffffff00點擊|r加載"
loader["|cffffff00Click|r to toggle the settings window"] = "|cffffff00點擊|r打開設定視窗"
loader["Deus Vox Encounters"] = "Deus Vox 首領戰鬥"

AL:GetLocale("DXE").loader = AL:GetLocale("DXE Loader")

return
end
