local L,SN,ST = DXE.L,DXE.SN,DXE.ST

---------------------------------
-- LICH KING
---------------------------------

do
	local data = {
		version = 68,
		key = "lichking",
		zone = L.zone["Icecrown Citadel"],
		category = L.zone["Citadel"],
		name = L.npc_citadel["Lich King"],
		triggers = {
			scan = 36597, -- Lich King
			yell = L.chat_citadel["^So the Light's vaunted justice has finally arrived"],
		},
		onactivate = {
			tracerstart = true,
--			tracerstop = true,
--			combatstop = true,
			tracing = {
				36597, -- Lich King
			},
			defeat = 36597,
		},
		onstart = {
			{
				"expect",{"#1#","find",L.chat_citadel["^So the Light's vaunted justice has finally arrived"]},
				"set",{phase = "RP"},
				"alert","zerotoonecd",
			},
			-- backup tracerstart
			{
				"expect",{"<phase>","==","0"},
				"alert","enragecd",
				"alert",{"infestcd",time = 2},
				"alert","necroplaguecd",
				"expect",{"&difficulty&",">=","3"},
				"alert","trapcd",
			},
		},
		userdata = {
			phase = "0",
			nextphase = {"T1","2","T2","3",loop = false, type = "series"},
		},
		alerts = {
			zerotoonecd = {
				varname = format(L.alert["%s Timer"],L.alert["Phase One"]),
				type = "centerpopup",
				text = format(L.alert["%s Begins"],L.alert["Phase One"]),
				time = 53.5,
				flashtime = 20,
				color1 = "MIDGREY",
				icon = ST[3648],
			},
			enragecd = {
				varname = L.alert["Enrage"],
				type = "dropdown",
				text = L.alert["Enrage"],
				time = 900,
				flashtime = 10,
				color1 = "RED",
				icon = ST[12317],
				behavior = "overwrite",
			},
			necroplaguecd = {
				varname = format(L.alert["%s Cooldown"],SN[70337]),
				type = "dropdown",
				text = format(L.alert["Next %s"],SN[70337]),
				time = 30,
				flashtime = 10,
				color1 = "MAGENTA",
				icon = ST[70337],
				counter = true,
				behavior = "overwrite",
				audiocd = 5,
			},
			necroplaguedur = {
				varname = format(L.alert["%s Duration"],SN[70337]),
				type = "centerpopup",
				text = format("%s: #5#!",SN[70338]),
				time = 5,
				flashtime = 5,
				color1 = "GREEN",
				icon = ST[70337],
			},
			necroplagueself = {
				varname = format(L.alert["%s on self"],SN[70337]),
				type = "centerpopup",
				text = format("%s: %s!",SN[70337],L.alert["YOU"]).."!",
				time = 5,
				flashtime = 5,
				color1 = "GREEN",
				sound = "ALERT3",
				icon = ST[70337],
				flashscreen = true,
			},
			shamblinghorrorwarn = {
				varname = format(L.alert["%s Warning"],L.npc_citadel["Shambling Horror"]),
				type = "centerpopup",
				text = SN[70372].."!",
				time = 1,
				color1 = "WHITE",
				sound = "ALERT5",
				icon = ST[70372],
			},
			shamblinghorrorcd = {
				varname = format(L.alert["%s Cooldown"],L.npc_citadel["Shambling Horror"]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],L.npc_citadel["Shambling Horror"]),
				time = 60,
				flashtime = 10,
				color1 = "BROWN",
				icon = ST[70372],
				behavior = "overwrite",
			},
			shamblinghorrorenragewarn = {
				varname = format(L.alert["%s Warning"],format("%s %s",L.npc_citadel["Shambling Horror"],SN[72143])),
				type = "simple",
				text = format("%s: %s",SN[72143],L.npc_citadel["Shambling Horror"]),
				time = 5,
				color1 = "PEACH",
				sound = "ALERT4",
				icon = ST[72143],
			},
			defilewarn = {
				varname = format(L.alert["%s on others"],format(L.alert["%s Casting"],SN[72762])),
				type = "centerpopup",
				text = format("%s: &upvalue&!",SN[72762]),
				time = 2,
				flashtime = 2,
				color1 = "PURPLE",
				icon = ST[72762],
			},
			defileselfwarn = {
				varname = format(L.alert["%s on self"],format(L.alert["%s Casting"],SN[72762])),
				type = "centerpopup",
				text = format("%s: %s!",SN[72762],L.alert["YOU"]),
				text2 = format(L.alert["%s Cast"],SN[72762]),
				time = 2,
				flashtime = 2,
				color1 = "PURPLE",
				sound = "ALERT3",
				flashscreen = true,
				icon = ST[72762],
			},
			defileself = {
				varname = format(L.alert["%s on self"],SN[72762]),
				type = "simple",
				text = format("%s: %s! %s!",SN[72762],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				flashscreen = true,
				sound = "ALERT3",
				throttle = 4,
				icon = ST[72762],
			},
			defilecd = {
				varname = format(L.alert["%s Cooldown"],SN[72762]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[72762]),
				time = 32,
				time2 = 37,
				flashtime = 10,
				color1 = "PURPLE",
				throttle = 2,
				icon = ST[72762],
				audiocd = 5,
			},
			remorsewarn = {
				varname = format(L.alert["%s Casting"],SN[68981]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[68981]),
				time = 2.5,
				color1 = "INDIGO",
				sound = "ALERT5",
				icon = ST[68981],
			},
			remorseself = {
				varname = format(L.alert["%s on self"],SN[68981]),
				type = "simple",
				text = format("%s: %s! %s!",SN[68981],L.alert["YOU"],L.alert["MOVE AWAY"]),
				time = 3,
				throttle = 4,
				icon = ST[68981],
				flashscreen = true,
			},
			remorsedur = {
				varname = format(L.alert["%s Duration"],SN[68981]),
				type = "centerpopup",
				text = format(L.alert["%s Duration"],SN[68981]),
				time = 60,
				flashtime = 10,
				color1 = "BLUE",
				icon = ST[68981],
			},
			quakewarn = {
				varname = format(L.alert["%s Warning"],SN[72262]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[72262]),
				time = 1.5,
				color1 = "CYAN",
				sound = "ALERT5",
				icon = ST[72262],
			},
			valkyrwarn = {
				varname = format(L.alert["%s Warning"],SN[69037]),
				type = "simple",
				text = SN[71843].."!",
				time = 4,
				sound = "ALERT5",
				icon = ST[71843],
				throttle = 4.5,
			},
			valkyrcarrywarn = {
				varname = format(L.alert["%s Warning"],SN[74445]),
				type = "simple",
				text = format("%s: &vehiclenames&",L.npc_citadel["Val'kyr"]),
				time = 5,
				icon = ST[74445],
			},
			valkyrcd = {
				varname = format(L.alert["%s Cooldown"],SN[69037]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69037]),
				time = {20,47,loop = false, type = "series"},
				flashtime = 10,
				color1 = "BROWN",
				icon = ST[71843],
				throttle = 4.5,
			},
			soulreapercd = {
				varname = format(L.alert["%s Cooldown"],SN[69409]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69409]),
				time = 30,
				time2 = 41,
				flashtime = 10,
				color1 = "ORANGE",
				icon = ST[69409],
				behavior = "overwrite",
			},
			soulreaperwarn = {
				varname = format(L.alert["%s Duration"],SN[69409]),
				type = "centerpopup",
				text = format("%s: &dstname_or_YOU&",SN[69409]),
				time = 5,
				color1 = "ORANGE",
				icon = ST[69409],
			},
			ragingspiritself = {
				varname = format(L.alert["%s on self"],SN[69200]),
				type = "simple",
				text = format("%s: %s! %s!",SN[69200],L.alert["YOU"],L.alert["MOVE"]),
				time = 4,
				color1 = "BLACK",
				sound = "ALERT5",
				flashscreen = true,
				icon = ST[69200],
			},
			ragingspiritwarn = {
				varname = format(L.alert["%s on others"],SN[69200]),
				type = "simple",
				text = format("%s: #5#!",SN[69200]),
				time = 4,
				color1 = "BLACK",
				sound = "ALERT5",
				icon = ST[69200],
			},
			ragingspiritcd = {
				varname = format(L.alert["%s Cooldown"],SN[69200]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[69200]),
				time = 22, -- after T1
				time2 = 18, -- after P1|P2
				time3 = 6, -- after T2
				flashtime = 5,
				color1 = "YELLOW",
				icon = ST[69200],
				behavior = "overwrite",
			},
			infestcd = {
				varname = format(L.alert["%s Cooldown"],SN[70541]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[70541]),
				time = 22,
				time2 = 6,
				time3 = 13,
				flashtime = 10,
				color1 = "YELLOW",
				icon = ST[70541],
				behavior = "overwrite",
			},
			infestwarn = {
				varname = format(L.alert["%s Warning"],SN[70541]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[70541]),
				time = 2,
				color1 = "YELLOW",
				icon = ST[70541],
			},
			vilespiritwarn = {
				varname = format(L.alert["%s Warning"],SN[70498]),
				type = "centerpopup",
				text = format(L.alert["%s Casting"],SN[70498]),
				time = 5.5,
				color1 = "MAGENTA",
				sound = "ALERT5",
				icon = ST[70498],
			},
			vilespiritcd = {
				varname = format(L.alert["%s Cooldown"],SN[70498]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[70498]),
				time = {18.9,30.5, loop = false, type = "series"}, -- most of the time it's 20.5 initially
				time2 = 30.5,
				color1 = "PINK",
				behavior = "overwrite",
				icon = ST[70498],
			},
			harvestsoulwarn = {
				varname = format(L.alert["%s Warning"],SN[68980]),
				type = "centerpopup",
				text = format("%s: &dstname_or_YOU&!",SN[68980]),
				text2 = format(L.alert["%s Warning"],SN[74297]),
				color1 = "BLACK",
				time = 6,
				sound = "ALERT4",
				icon = ST[68980],
			},
			harvestsoulcd = {
				varname = format(L.alert["%s Cooldown"],SN[68980]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],SN[68980]),
				text2 = format(L.alert["%s Cooldown"],SN[74297]),
				time = {12.5,75,loop = false, type = "series"},
				time2 = {12.5,55,loop = false, type = "series"},
				flashtime = 10,
				color1 = "BROWN",
				icon = ST[68980],
			},
			restoresoulwarn = {
				varname = format(L.alert["%s Casting"],SN[73650]),
				type = "dropdown",
				text = format(L.alert["%s Casting"],SN[73650]),
				color1 = "GOLD",
				time = 40,
				flashtime = 20,
				icon = ST[73650],
			},
			trapwarn = {
				varname = format(L.alert["%s Casting"],L.alert["Shadow Trap"]),
				type = "simple",
				text = format("%s: %s!",L.alert["Shadow Trap"],L.alert["YOU"]),
				text2 = format("%s: &upvalue&!",L.alert["Shadow Trap"]),
				text3 = format(L.alert["%s Casting"],L.alert["Shadow Trap"]),
				time = 3,
				color1 = "BLACK",
				sound = "ALERT2",
				icon = ST[73539],
				flashscreen = true,
			},
			trapcd = {
				varname = format(L.alert["%s Cooldown"],L.alert["Shadow Trap"]),
				type = "dropdown",
				text = format(L.alert["%s Cooldown"],L.alert["Shadow Trap"]),
				time = {16.1,15.5,loop = false, type = "series"},
				flashtime = 7,
				color1 = "INDIGO",
				icon = ST[73539],
				behavior = "overwrite",
			},
			massrescd = {
				varname = format(L.alert["%s Timer"],SN[72429]),
				type = "centerpopup",
				text = SN[72429],
				time = 157.1,
				flashtime = 20,
				color1 = "MIDGREY",
				icon = ST[72429],
			},
		},
		announces = {
			defilesay = {
				varname = format(L.alert["Say %s on self"],SN[72762]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[72762]).."!",
			},
			trapsay = {
				varname = format(L.alert["Say %s on self"],L.alert["Shadow Trap"]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],L.alert["Shadow Trap"]).."!",
			},
			necroplaguesay = {
				varname = format(L.alert["Say %s on self"],SN[70337]),
				type = "SAY",
				msg = format(L.alert["%s on Me"],SN[70337]).."!",
			},
		},
		raidicons = {
			defilemark = {
				varname = SN[72762],
				type = "FRIENDLY",
				persist = 5,
				unit = "&upvalue&",
				icon = 1,
			},
			trapmark = {
				varname = L.alert["Shadow Trap"],
				type = "FRIENDLY",
				persist = 6,
				unit = "&upvalue&",
				icon = 1,
			},
			ragingspiritmark = {
				varname = SN[69200],
				type = "FRIENDLY",
				persist = 7.5,
				unit = "#5#",
				icon = 2,
			},
			harvestmark = {
				varname = SN[68980],
				type = "FRIENDLY",
				persist = 6,
				unit = "#5#",
				icon = 3,
			},
			necroplaguemark = {
				varname = SN[70337],
				type = "FRIENDLY",
				persist = 15,
				unit = "#5#",
				icon = 4,
			},
			valkyrmark = {
				varname = SN[69037],
				type = "MULTIENEMY",
				persist = 10,
				reset = 8,
				unit = "#4#",
				icon = 5,
				total = 3,
			}
		},
		arrows = {
			ragingspiritarrow = {
				varname = SN[69200],
				unit = "#5#",
				persist = 5,
				action = "TOWARD",
				msg = L.alert["KILL IT"],
				spell = SN[69200],
				fixed = true,
			},
			traparrow = {
				varname = L.alert["Shadow Trap"],
				unit = "&upvalue&",
				persist = 5,
				action = "AWAY",
				msg = L.alert["MOVE AWAY"],
				spell = L.alert["Shadow Trap"],
				fixed = true,
				range1 = 5,
				range2 = 7,
				range3 = 10,
			},
		},
		events = {
			-- Yell
			{
				type = "event",
				event = "YELL",
				msg = L.chat_citadel["^I'll keep you alive to witness the end, Fordring"],
				execute = {
					{
						"set",{phase = "1"},
						"batchalert",{"enragecd","infestcd","necroplaguecd"},
						"resettimer",true,
						"expect",{"&difficulty&",">=","3"},
						"alert","trapcd",
					},
				},
			},
			-- Fury of Frostmourne
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72350,
				execute = {
					{
						"quashall",true,
						"alert","massrescd",
					},
				},
			},
			-- Shadow Trap
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 73539,
				execute = {
					{
						"target",{
							npcid = 36597, -- Lich King
							announce = "trapsay",
							raidicon = "trapmark",
							arrow = "traparrow",
							alerts = {
								self = "trapwarn",
								other = {"trapwarn",text = 2},
								unknown = {"trapwarn",text = 3},
							},
						},
						"alert","trapcd",
					},
				},
			},
			-- Necrotic Plague
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 70337,
				execute = {
					{
						"raidicon","necroplaguemark",
						"alert","necroplaguecd",
						"alert",{dstself = "necroplagueself",dstother = "necroplaguedur"},
					},
					{
						"expect",{"#4#","==","&playerguid&"},
						"announce","necroplaguesay",
					},
				},
			},
			-- Necrotic Plague dispel
			{
				type = "combatevent",
				eventtype = "SPELL_DISPEL",
				spellname2 = 70337,
				execute = {
					{
						"batchquash",{"necroplaguedur","necroplagueself"},
					},
				},
			},
			-- Summon Shambling Horror
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 70372,
				execute = {
					{
						"alert","shamblinghorrorwarn",
					},
				},
			},
			-- Summon Shambling Horror cooldown
			{
				type = "combatevent",
				eventtype = "SPELL_SUMMON",
				spellname = 70372,
				execute = {
					{
						"alert","shamblinghorrorcd",
					},
				},
			},
			-- Shambling Horror Enrage
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72143,
				srcnpcid = 37698, -- Shambling Horror
				execute = {
					{
						"alert","shamblinghorrorenragewarn",
					},
				},
			},
			-- Defile
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72762,
				execute = {
					{
						"alert","defilecd",
						"target",{
							npcid = 36597, -- Lich King
							announce = "defilesay",
							raidicon = "defilemark",
							alerts = {
								self = "defileselfwarn",
								other = "defilewarn",
								unknown = {"defileselfwarn",text = 2},
							},
						},
					},
				},
			},
			-- Defile self
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 72754,
				dstisplayerunit = true,
				execute = {
					{
						"alert","defileself",
					},
				},
			},
			-- Remorseless Winter
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 68981,
				execute = {
					{
						"alert","remorsewarn",
						"set",{phase = "<nextphase>"},
						"batchquash",{"necroplaguecd","defilecd","valkyrcd","infestcd","soulreapercd","shamblinghorrorcd","trapcd"},
						"alert",{"ragingspiritcd",time = 3},
					},
				},
			},
			-- Remorseless Winter app
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 68981,
				execute = {
					{
						"quash","remorsewarn",
						"alert","remorsedur",
					},
				},
			},
			-- Remorseless Winter self
			{
				type = "combatevent",
				eventtype = "SPELL_DAMAGE",
				spellname = 73791,
				dstisplayerunit = true,
				execute = {
					{
						"alert","remorseself",
					},
				},
			},
			-- Quake
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 72262,
				execute = {
					{
						"alert","quakewarn",
						"set",{phase = "<nextphase>"},
						"alert",{"defilecd",time = 2},
						"quash","ragingspiritcd",
					},
					{
						"expect",{"<phase>","==","2"},
						"alert","valkyrcd",
						"alert",{"soulreapercd",time = 2},
						"alert",{"infestcd",time = 3},
					},
					{
						"expect",{"<phase>","==","3"},
						"invoke",{
							{
								"expect",{"&difficulty&","<=","2"},
								"alert","soulreapercd",
								"alert","vilespiritcd",
								"alert","harvestsoulcd",
							},
						},
						"alert",{"harvestsoulcd", time = 2, text = 2, expect = {"&difficulty&",">=","3"}},
					},
				},
			},
			-- Summon Val'kyr
			{
				type = "combatevent",
				eventtype = "SPELL_SUMMON",
				spellname = 69037,
				srcnpcid = 36597,
				execute = {
					{
						"alert","valkyrwarn",
						"alert","valkyrcd",
						"raidicon","valkyrmark",
					},
				},
			},
			-- Summon Val'kyr 2
			{
				type = "combatevent",
				eventtype = "SPELL_SUMMON",
				spellname = 69037,
				srcnpcid = 36597,
				throttle = 6,
				execute = {
					{
						"schedulealert",{"valkyrcarrywarn",6.25},
					},
				},
			},
			-- Soul Reaper
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 69409,
				execute = {
					{
						"alert","soulreapercd",
						"alert","soulreaperwarn",
					},
				},
			},
			-- Raging Spirit
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 69200,
				execute = {
					{
						"raidicon","ragingspiritmark",
						"alert",{dstself = "ragingspiritself",dstother = "ragingspiritwarn"},
						"alert",{"ragingspiritcd",expect = {"<phase>","==","T1"}},
						"alert",{"ragingspiritcd",time = 2,expect = {"<phase>","==","T2"}},
					},
					{
						"expect",{"#4#","~=","&playerguid&"},
						"arrow","ragingspiritarrow",
					},
				},
			},
			-- Infest
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 70541,
				execute = {
					{
						"alert","infestwarn",
						"alert","infestcd",
					}
				},
			},
			-- Vile Spirits
			-- .5 second cast + 5 second channel
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 70498,
				execute = {
					{
						"alert","vilespiritwarn",
						"alert",{"vilespiritcd", expect = {"&difficulty&","<=","2"}},
						"alert",{"vilespiritcd", time = 2, expect = {"&difficulty&",">=","3"}},
					}
				},
			},
			-- Harvest Soul
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 68980,
				execute = {
					{
						"raidicon","harvestmark",
						"alert","harvestsoulcd",
						"alert","harvestsoulwarn",
					},
				},
			},
			-- Harvest Souls
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_SUCCESS",
				spellname = 74297,
				execute = {
					{
						"alert",{"harvestsoulwarn", text = 2},
						"batchquash",{"defilecd","soulreapercd","vilespiritcd"},
					},
				},
			},
			-- Restore Soul
			{
				type = "combatevent",
				eventtype = "SPELL_CAST_START",
				spellname = 73650,
				execute = {
					{
						"alert","restoresoulwarn",
					},
				},
			},
			-- Restore Soul appliation
			{
				type = "combatevent",
				eventtype = "SPELL_AURA_APPLIED",
				spellname = 73650,
				throttle = 3,
				execute = {
					{
						"alert",{"harvestsoulcd", text = 2, time = 2},
					},
				},
			},
		},
	}

	DXE:RegisterEncounter(data)
end


local lichfight = false
local lichking = CreateFrame("Frame")
lichking:SetScript("OnEvent",function(self,event,...) self[event](self,...) end)
lichking:RegisterEvent("ADDON_LOADED")


function lichking:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, spellID, spellName, school, ...)
	if lichfight and event == "SPELL_DISPEL" then
		PlagueScan()
	end
end

function lichking:CHAT_MSG_MONSTER_YELL(text, playerName, ...)
	if strfind(text, L.chat_citadel["^So the Light's vaunted justice has finally arrived"]) then
		lichfight = true
		lichking:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

do
	local plague = GetSpellInfo(70337)
	local function scanRaid()
		for i = 1, GetNumRaidMembers() do
			local player = GetRaidRosterInfo(i)
			if player then
				local debuffed, _, _, _, _, _, expire = UnitDebuff(player, plague)
				if debuffed and (expire - GetTime()) > 13 then
--					if UnitIsUnit(player, "player") then 
						DXE.Alerts.CenterPopup(_, "necroplaguedur", format("%s: %s!", SN[70337], player).."!", 5, 5, "ALERT3", "GREEN", "GREEN", false, DXE.ST[70337])
--					end
				end
			end
		end
	end
	function PlagueScan()
		DXE:ScheduleTimer(scanRaid, 0.5)
	end
end

function lichking:ADDON_LOADED() 
	lichking:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	lichfight = false
end